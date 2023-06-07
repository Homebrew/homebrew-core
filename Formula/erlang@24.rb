class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.12/otp_src_24.3.4.12.tar.gz"
  sha256 "0361252c3efb600d60033c15f2a6d97c552ce0272719f7b23af11304bee2d69c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20993ccc536af110701c781b38a7f57c9e99e18506551b40c0edc975bb683b9c"
    sha256 cellar: :any,                 arm64_monterey: "0cc6f0558fe4bbd6ed2e7e541f61514f0063a5d0f746e87424f74611955d2b16"
    sha256 cellar: :any,                 arm64_big_sur:  "eff3d6269616d7fabbe71db0eae47ceb9c68b53368f50c8e87a693467e0e1b0c"
    sha256 cellar: :any,                 ventura:        "ae0bef5e538f2723be736e99373619637c04b8c8414cf3b2a0aa18b95e5bfa00"
    sha256 cellar: :any,                 monterey:       "bc25602cfbf7ee7ec852007f19c9447cd3f7c6047ae5cdf2f7e5d4c56ec6c104"
    sha256 cellar: :any,                 big_sur:        "3e40e16a5a6cc3ac71d328675f6a1335bcbadfbe30bf0fad8a93bf8b37865a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dec67b4dec91d464950e49eabeee10ed9d5d094b869569a93162bc8107dcf64"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.12/otp_doc_html_24.3.4.12.tar.gz"
    sha256 "5c4d03313b1fcafb40987e826e8a88daa8b0651b7c16e5da7d8bea81acc51e37"
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
