class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.8/otp_src_26.2.5.8.tar.gz"
  sha256 "74495ceb8b57b09c9bca86376d09396a461514bbdbdbee6c152ad2c47e61059d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bc81c4e4088732d27913a214ad935b680101aa128a3f85caa6e1202c10970976"
    sha256 cellar: :any,                 arm64_sonoma:  "b1c31f43ca9b67ab1e47948ab8e30ff011a5812825a6d48d65b01b3b4e531191"
    sha256 cellar: :any,                 arm64_ventura: "82c4796c80b6a78e63f9a0accd7b2dfe6a9841e54238984bea49306e7e36e486"
    sha256 cellar: :any,                 sonoma:        "959d3d6a7c57b4cb06599efd1b3cfd1b16249960b0405265b71c682cba7a8bbb"
    sha256 cellar: :any,                 ventura:       "f4a425fda083938922669e1ff1762345fde675d9f58d557f0cfbabc20460bae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd2e8ae50927684da0a9055bc9594789bc53d51a5f4c8ffd4ab560978e8e349"
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
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.8/otp_doc_html_26.2.5.8.tar.gz"
    sha256 "664eabbce51aca4eec5d7b905bc0acc599871b1186c7ca6f5381a7e52c58c75f"

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
