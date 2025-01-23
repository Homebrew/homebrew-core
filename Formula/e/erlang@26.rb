class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.6/otp_src_26.2.5.6.tar.gz"
  sha256 "96ce3340450756fdabf8fdb2e3ceb0489eb679f6b51b7b7ac6417c2e6f495bb8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9776ab634a1a2c06ea9b2e20bd9eb3e2ea13c2ddcb28f56285aced00a459e8a3"
    sha256 cellar: :any,                 arm64_sonoma:  "1ba9d5850dab17911d4939117a7d9e2e7f7668678f08ad314f1e2e7977ed00cd"
    sha256 cellar: :any,                 arm64_ventura: "e1a9f210e3c052aa7f0e272e0ad47b2aaeeed1ad6e3cf68c3426b30a6e279319"
    sha256 cellar: :any,                 sonoma:        "c32bc73ee5f71cc591767057ed7b2fbb6493c82174493f0c37a2fe301510833e"
    sha256 cellar: :any,                 ventura:       "bf2cfd450620bb146a306b520e2af16090c395ab78d6370aecec31444bcf9dde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638d1c0c6a0a4e1806334ff3596a3dc7370e1170e255c0f84d0f00a329a6fee5"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.6/otp_doc_html_26.2.5.6.tar.gz"
    sha256 "710fd347fcca0c3262db14c0711c1dace7c31385bea3f2ace6e024590e3d0338"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system bin/"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS

    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
