class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.11/otp_src_24.3.4.11.tar.gz"
  sha256 "0e63cd975f126ae9f17c36062d63e8629bb984e013b18a8a13ad634035dc414f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2927c8be579ee782c0320af83041309d6b1c8f8341f4bb0b4433c96b6c745db8"
    sha256 cellar: :any,                 arm64_monterey: "30b85e41e287291ea47127e5a4400f2d3083e892afa0761efd2df2aeed1fcbfa"
    sha256 cellar: :any,                 arm64_big_sur:  "5b524ef0725b00700292eae8e797d17a278d720ad890d0c9938f60f57359cd7b"
    sha256 cellar: :any,                 ventura:        "ba73596aa6e6334a36d65e68b292732cddf3ddacd030d5bb85d91da9fbc7e2cb"
    sha256 cellar: :any,                 monterey:       "080d179a4ad65ec30194aff22b1e5588d021726fbeb013250ce70963a852d19a"
    sha256 cellar: :any,                 big_sur:        "bcb65cd28b4ac101e103e4a3961e4e9e0881313b40fc6ab278e9d74deb5d9e34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19715654f080880e88c42dc0b5bc2b85c1fccc164885db04825416c7823221b4"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.11/otp_doc_html_24.3.4.11.tar.gz"
    sha256 "4b77099afa3a8fa516fc14bbfb36715bf945cc2bc43e4a8c0419540b3d05e0b5"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
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

    system "./configure", *args
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
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
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
