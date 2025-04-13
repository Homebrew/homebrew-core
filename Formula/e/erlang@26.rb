class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.10/otp_src_26.2.5.10.tar.gz"
  sha256 "e70265e3df9a5df831d6246bd379ead54ab8430d00cb4a9ba396a7dfcbb33a9b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4bf63c67a7715d97c30506c07708a0594f2e15b1b7d12222594d8266053dfe9c"
    sha256 cellar: :any,                 arm64_sonoma:  "7be4604f762f322a0a2dc47c3a8d1303c60db675691eda7ecd2e277b7fbc1189"
    sha256 cellar: :any,                 arm64_ventura: "75aad02516ef5094b52330317f31d11ce96e8baced6e9dbec1de31ecd78d0839"
    sha256 cellar: :any,                 sonoma:        "608b2e3485b37f5943de5482b6f7f244aa820a32d9da464683371a7726123977"
    sha256 cellar: :any,                 ventura:       "2c47c0fe74e226fe83a23defbcbb729d14824c0f6e1f6f3d92c9040443ac4faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "687b5b106ba02b4228ed06cc95389e1684e684002932f10a5d72516059b30025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c741c2fec9c3e32a2be077a7bdf369ebb611fb932db3d18d4319ee7751dd3d"
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
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.10/otp_doc_html_26.2.5.10.tar.gz"
    sha256 "7360cb611dda89f4f60bdf40613235be29d1d61ee793c07d1d6235fee73eebf9"

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
