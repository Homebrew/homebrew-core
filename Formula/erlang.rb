class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.2/otp_src_25.3.2.2.tar.gz"
  sha256 "83a36f3d90deef36adb615bbfb46cd327f0b76b7668e1f7f253fd66b4ae24518"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c033023b8c2b5e30b626872cb5ac0523f7c776ddce4b91cf258fff63b90eb24c"
    sha256 cellar: :any,                 arm64_monterey: "715c89495305b1f63d377693e20810a5b58af7fccdb886338a58b4d0ea527713"
    sha256 cellar: :any,                 arm64_big_sur:  "8f9f0b05610f8ab438e719410581c45e538dad15eaae92183e64e53570553d73"
    sha256 cellar: :any,                 ventura:        "1fb27af450a67af5a729e915a42fee16d0bd7ea17c10d1a29c01fc70be67f208"
    sha256 cellar: :any,                 monterey:       "03e1f91735382040b03dc99d879b4681d13f81bed71804d4376312d9cf0d4c58"
    sha256 cellar: :any,                 big_sur:        "0b345a0cb43ee612179bb36a2ef8179c0d3fd5308b3efd9798d8fbeae64cdc37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1662a10af5e168aa34c74946720f0f8164b7348ec73c462b1e3fdbe0315afa9"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
