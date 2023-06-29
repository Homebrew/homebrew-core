class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.2/otp_src_25.3.2.2.tar.gz"
  sha256 "83a36f3d90deef36adb615bbfb46cd327f0b76b7668e1f7f253fd66b4ae24518"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ffca81847dba5145ec5c68cb08c70456b8a564277a669e35fd0f399e8d9e788f"
    sha256 cellar: :any,                 arm64_monterey: "e9038009d38dfa8e17bb1d885cd7876f216895d0f97277841f7136deb2f5d2d1"
    sha256 cellar: :any,                 arm64_big_sur:  "7bb0002c0bbf3b8d9d7f2c0a9ed29c28631d33f3b30c9e92926c31ef249f71fb"
    sha256 cellar: :any,                 ventura:        "fd5a184da27efc3179ea50cbfdc972ef1403ad715d8b4ba07fbb78d5c40aef14"
    sha256 cellar: :any,                 monterey:       "f691cd70a744053bafe283060aeae61384fad9cb23257797568c294f104707f2"
    sha256 cellar: :any,                 big_sur:        "e8147cc1a51a0d1b221b5691fb2eb1b28c5bb2415271e8a56a310f4cd270a410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63f3846233a10a2b96573fb41e694d234c20f95f0d54b0e626933a274030837"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.2/otp_doc_html_25.3.2.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.3.2.2.tar.gz"
    sha256 "29412cd7d490aeee51a5386faceee357fe134ba10fdeed44c224242a2e0a66d4"
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
