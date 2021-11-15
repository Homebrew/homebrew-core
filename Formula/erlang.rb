class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.1.5/otp_src_24.1.5.tar.gz"
  sha256 "a6b28da8a6382d174bb18be781476c7ce36aae792887dc629f331b227dfad542"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "357bb2334f1a6ffd5cbbc718df6f0fd76d24a6a65abcb68c9a676fe74ef5773d"
    sha256 cellar: :any,                 arm64_big_sur:  "4cd6af60a84cf22f7bf2c3b3ada489096b8cecc4f684ccbe2fffcb848f84ea85"
    sha256 cellar: :any,                 monterey:       "cbcf9a549ef70b1224782514726fe97694fda039820518d66d3fa11da7687e3f"
    sha256 cellar: :any,                 big_sur:        "58035ac5df0b30878a0f377304bbb357de6837e279528ed1fe38d382af331e31"
    sha256 cellar: :any,                 catalina:       "7fd943c6a7c51aa6c7143bb6e6488980bb43ea83497d761deeebf0727ec3d4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea11d8e494afb155f70c600daa6260410b252898192ab0251dc99e7c1e6a1b3"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.1.5/otp_doc_html_24.1.5.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.1.5.tar.gz"
    sha256 "2bf87fa8c005e4c39264cf9696ee98e67fbe880c66f5f2291eea7e335c6eb1b4"
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
