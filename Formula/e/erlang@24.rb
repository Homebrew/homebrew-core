class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.15/otp_src_24.3.4.15.tar.gz"
  sha256 "d951d2fdcc4f5c8c3d5677c0644782283c8f2183d4fb53868deff2d09256121a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "edcd2664500c00f4e19dc93c3b38cbabba2f0f076c0f239e3e3cf016611aa577"
    sha256 cellar: :any,                 arm64_ventura:  "9b76c345946afe7a7a96f3bd0269cdac62d42cbc522d8739f02f05561c947f48"
    sha256 cellar: :any,                 arm64_monterey: "fa9f78ed822d3bec3e13b968b82df0907199a14b055f2af809f15be5a22dd261"
    sha256 cellar: :any,                 sonoma:         "16531bd421dfbbc68312467bd84fff71b59e5df0478f47d8a55b177e9e08fe90"
    sha256 cellar: :any,                 ventura:        "aa7e98565307556dfede6e3adbfad3fd23d96a8e75a579fdbb6d2bebbd79f333"
    sha256 cellar: :any,                 monterey:       "c49265892ef09ceb0df484aeae734ba3bb203ce6c364cd4a1fd2ccd6fa9eaa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3e4f3c37599497df50c5f9d4dca5891a55fca3685580e7c3f37c4338555241"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.15/otp_doc_html_24.3.4.15.tar.gz"
    sha256 "62c2cf7081d04a56f3751e747409a3968788f85becae70266e50cd2097b6e8f1"
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
    assert_equal version, resource("html").version, "`html` resource needs updating!"

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
