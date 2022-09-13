class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.5/otp_src_24.3.4.5.tar.gz"
  sha256 "0b57d49e62958350676e8f32a39008d420dca4bc20f2d7e38c0671ab2ba62f14"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a362e24a39edd5f39a8cee93340f3daeb93dbde91c620a3b1a4bb255d73d5bd9"
    sha256 cellar: :any,                 arm64_big_sur:  "7aac8d1aa978b82590f396c1461e0f84ced833732ae16bb35244b0aeafd04d2b"
    sha256 cellar: :any,                 monterey:       "f6226b96b154a448ebb0ad2fc47fcc530b6111fae81e16eb8ea62ca4544c4ffe"
    sha256 cellar: :any,                 big_sur:        "7ef8b59d2415188917ef2c899492ded733610cca451ed58a72fd8218a48ddd14"
    sha256 cellar: :any,                 catalina:       "113c42c11e905bae630842c8b1a0352edf107480ea35cf0241bf1de88aa880a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa8de658c28566eebd0e9ac6328e7b4ce89c87665e46863d8f7048e1e37a62d"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.5/otp_doc_html_24.3.4.5.tar.gz"
    sha256 "fdbf945ba3a9cfd8ac59e8d6888cb18983e4e99982fbc0ea028e7e014aaaa641"
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
    system "make", "docs", "DOC_TARGETS=chunks"
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
