class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.1/otp_src_26.2.1.tar.gz"
  sha256 "80d66bafbae409481a4e1badcb4a6275b07a8e9af82980c08d7a8add483232a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2d400dd1ef94e64463f3270d42ce49097c0c832ba3df4072546c33a17d085fea"
    sha256 cellar: :any,                 arm64_ventura:  "bea2f051ea53d5ec4e7f2388d0fe3252c2985b6f2d93132003cae841980ca1df"
    sha256 cellar: :any,                 arm64_monterey: "e166454215af6ef092c3bc575c6aa4db0d037e3f07789e4895f4c7fdc119033c"
    sha256 cellar: :any,                 sonoma:         "4961117ddedb5220100d457d33f75526858f2aa63696b385a0b4fdd651862855"
    sha256 cellar: :any,                 ventura:        "fa46ebc7a72c8d4f29662b9542c987fb6ec5c22a05a1b6592949fab339bceaf0"
    sha256 cellar: :any,                 monterey:       "baa3c926f867a47ad8c2bee4c249f75d7097620c9921bead24ac852e933ca07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2462ccf25206837c622336579af4c38bb03056868770c4b165fbfd2c6f8e2b02"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.1/otp_doc_html_26.2.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_26.2.1.tar.gz"
    sha256 "73496b9751ee8904e92319baea4fcf3287f366fbcd17241814d8e8be14a8cc6e"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
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

    system "./configure", *std_configure_args, *args
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
