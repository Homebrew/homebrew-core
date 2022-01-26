class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.2.1/otp_src_24.2.1.tar.gz"
  sha256 "380a77aef34ad449bf8370a380b7901364b9be23e3d25068fc5c43258bcbec11"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f8c9b9ccd1380cf431c70e8a973227a947bc4681902dbf803404a97d54bc0c67"
    sha256 cellar: :any,                 arm64_big_sur:  "fb471b0c14aad3873beeebb95c47cc3d82b1fb127fe694694549580cccb1edab"
    sha256 cellar: :any,                 monterey:       "7693fc6c567a6efeb68bd3aadf6552ad549af39429e2e93bad53fdfba1e4633d"
    sha256 cellar: :any,                 big_sur:        "dfe54dc96851cb845bdc8f0a4ee9710ba7b47af8735d301b907da9cbe9a36774"
    sha256 cellar: :any,                 catalina:       "2e3bf2925d77926a869918b93f4a25ec5426ee91fd9b1eaf3c425da314f25fc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c4daea1b09479febdfe5a360df78d349c7d02860e785aabbacdbb321a15b4c"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.2.1/otp_doc_html_24.2.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.2.1.tar.gz"
    sha256 "9b326b6d6238fdcd2846e0f086563af0897e80b0d36a8c6caddb925329c3ecfd"
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
