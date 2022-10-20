class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.18/otp_src_23.3.4.18.tar.gz"
  sha256 "fde15701e97cce3a036108ead20409c87a81c6ad3421ece5b66bd4d26dcb1cb7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "873e8559a4dc7dccd620fec6bc4038b5783afb14c9aed9d5b32d57b992f0312b"
    sha256 cellar: :any,                 arm64_big_sur:  "6325b9ad8d34d4710fb5ee640e8840f01b4369e8cc27b79f3fe1254ee578671b"
    sha256 cellar: :any,                 monterey:       "9f8c4fd3f065f2caa607207621d3f98185dfa29e710efdb64022b4e040f85ed4"
    sha256 cellar: :any,                 big_sur:        "8378dfc63b87f9c1122ee76a88b56ed679219f236fe9207c8737cb240a963df3"
    sha256 cellar: :any,                 catalina:       "753d4605ec12f65c3b3ff8f6bbe9aab034f9b7467c2bfecd88a25874d50e849b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fcc177755caf8a95dccba16071afc2a8e34dd3fccd3ed4c5abdc9441aa74b84"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.18/otp_doc_html_23.3.4.18.tar.gz"
    sha256 "61e09ef289fe3cc77ca43c0be0d7bd377650f8442d825ea833ff2758d703d998"
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
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

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
