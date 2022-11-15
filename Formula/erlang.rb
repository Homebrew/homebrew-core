class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.1.1/otp_src_25.1.1.tar.gz"
  sha256 "42840c32e13a27bdb2c376d69aa22466513d441bfe5eb882de23baf8218308d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c5b102fc83a6595f7b91073d696bb35fdf34313668181cafa4a6b9c7d24198a"
    sha256 cellar: :any,                 arm64_monterey: "d9ce4e28894301e8ac83a22920f221f6883a483a9f5f45848751c2ba65647bbc"
    sha256 cellar: :any,                 arm64_big_sur:  "a0ada560afed6f7d0a1bef62aa81bce1308313cb01fc2e3aea8a94401f0edd4c"
    sha256 cellar: :any,                 ventura:        "6546978a79a98046c4705d83025c88e69b57a72a3e65d93614a0a9469c6376dc"
    sha256 cellar: :any,                 monterey:       "e823d48b6b8dc234bc3bcb61e9b39b418c9bd54e920bc6ddb968305dbf4a7a1f"
    sha256 cellar: :any,                 big_sur:        "db3b43cf08ab4b598230c96499159653577ef1185ab1206b6f3d810944d9dc0d"
    sha256 cellar: :any,                 catalina:       "ed674b2d180619df566795ec2fd35352d9957985eb228d6354f2d39f2af6884c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bec814096255797bf28d8d67f7586aefe32a9caf34f510131ea095b4964056f"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.1.1/otp_doc_html_25.1.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.1.1.tar.gz"
    sha256 "cddaea522aa5911d93fe0cd4ac9cc7d27d399842d1357d293a2d5b9944b98d08"
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
