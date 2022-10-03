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
    sha256 cellar: :any,                 arm64_monterey: "430afd2dd1e3ec013261372c91114cb750677b7e5aee45ed12e68bdd4cf1a11b"
    sha256 cellar: :any,                 arm64_big_sur:  "a0ed2fc808169dca3fd5a04237619c6cfaca074997c9c5c2ad04c1a848cd42a4"
    sha256 cellar: :any,                 monterey:       "ec3ff49817a9df566cb5f634531dc0acf27c9f5426da5be9662eb75f3a5d6fa1"
    sha256 cellar: :any,                 big_sur:        "1da117b12e9fe83fba8e19ec4642b75748bf05afed4dcd57d041a1301ef63679"
    sha256 cellar: :any,                 catalina:       "dcfa5f2552f0a3baa59807f3d9c649430686ddf2a30ed96a11639cbf276189a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b3037186b78cf1682534083aeb19213c05cf9e90486349f9165066d7e13816"
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
