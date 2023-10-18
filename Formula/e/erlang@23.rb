class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.19/otp_src_23.3.4.19.tar.gz"
  sha256 "b830af3d9fcb0be88d1d358ee8d5db6dbc51554329053b7dfdc17d4335c81302"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6665262be9fe6ea5df2a84909be0796aca5d988a4b29bc4624ae7f78858340df"
    sha256 cellar: :any,                 arm64_ventura:  "5a5e15453d8187ff2af7c17244e05eab49a9bc5d3d9a50b3e432afa9a5eaf3ff"
    sha256 cellar: :any,                 arm64_monterey: "91d455b6b301fa047d499aa17a695e131a04824d09e2bf31396faea911ebc6d5"
    sha256 cellar: :any,                 arm64_big_sur:  "437f7005eef622897075dd775cdcf83a94952c6bef75a00e69e856646cf7f466"
    sha256 cellar: :any,                 sonoma:         "91a79f5b167be82d82ba77ff4d203f67a03dd9c8ae74555df27c32afddb31a91"
    sha256 cellar: :any,                 ventura:        "f2fa27f3b44ca454fe27238adfb03f37ab9d68680d35d7625e68c82ce2c47d2d"
    sha256 cellar: :any,                 monterey:       "3038f4dbb5e7859f5c2a896d8c05719c1ccb13aa760cf6db188ea8f0fd738036"
    sha256 cellar: :any,                 big_sur:        "dd949b7401353b74b1f4924950957590de21c197c03eb995aee7dede60d9f766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d88450517f23ca316e5263f1db6b4b90d1663239bd06607a2695dbf44642906"
  end

  keg_only :versioned_formula

  # EOL with OTP-26 release. Also does not support OpenSSL 3.
  deprecate! date: "2023-07-01", because: :unsupported

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.19/otp_doc_html_23.3.4.19.tar.gz"
    sha256 "bea2315dc33ecc04dd2e26a4d418d03dced3a7f326f146ce8cfefc9f23c6cada"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
