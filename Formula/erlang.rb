class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-23.3.3.tar.gz"
  sha256 "839d74e71a457295d95b8674f1848a5d7d9c4c274a041ef8026d035da88858ae"
  license "Apache-2.0"
  head "https://github.com/erlang/otp.git"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "685b6113c3851edc9798179927836a60d0d3c6cd4b15f60a4e0eb591c708332d"
    sha256 cellar: :any, big_sur:       "d6afac2250d3ca3090d417e48815c4dd1a2498c34a7c362577f1c809a88c2dae"
    sha256 cellar: :any, catalina:      "fcb0e53b00a8b90ab2a4d32cb3afd17187e2e0a36af7ca9eead1d84cdb77e753"
    sha256 cellar: :any, mojave:        "15f44cde591aa100f2097114b7f7dd8a08c7ba94d1fac5c7f20fa23f8b743838"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_23.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_23.3.tar.gz"
    sha256 "03d86ac3e71bb58e27d01743a9668c7a1265b573541d4111590f0f3ec334383e"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    on_macos do
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
