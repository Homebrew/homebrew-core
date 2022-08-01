class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.0.3/otp_src_25.0.3.tar.gz"
  sha256 "0d7558bc16f3e6b61964521e0157e1a75aad1770bb08af10366ea4c83441ec28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e6b6bd9e0a5830787f833add6a346bc08443ea7881885963160e393882ef799"
    sha256 cellar: :any,                 arm64_big_sur:  "b28e24fbd99799d436915260f4350e5305c40f632df715f0ad5d30eb3fbf563d"
    sha256 cellar: :any,                 monterey:       "c57ff550411b04a6b1f7b46e2092c218fdb512d2d29a4c49de888e0a78cc2203"
    sha256 cellar: :any,                 big_sur:        "4271aa91431b9cb315c4a334fde1d74d464dd1f4a7ea0f4d8772cfcc3100a7b4"
    sha256 cellar: :any,                 catalina:       "818627cbb0f2463598957872ac819727a55c7fbd9a36804788f45364f87daf9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a758b19fc68cb1f7b83246cc8207230149bdba861e4865b0495271af74f3c03c"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.0.3/otp_doc_html_25.0.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.0.3.tar.gz"
    sha256 "59bac9849eb262c9cac1fa7d4bf1e82cfbea23e453f074f1f3582a41545303dd"
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
