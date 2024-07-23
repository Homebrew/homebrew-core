class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.0.1/otp_src_27.0.1.tar.gz"
  sha256 "26d894e2f0dda9d13560af08ea589afc01569df6b5486e565beb5accb99c9cf4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d2e8be34e595f3890cb64a5b99c78f2a089fd4261a3c6e745651c8fb9451b4c"
    sha256 cellar: :any,                 arm64_ventura:  "26535a5c94a185ee1d4fb29a3e5a8f767faa5a641b373be3eb95210486e073fd"
    sha256 cellar: :any,                 arm64_monterey: "63a93a3c81af03f1d2717cfd5c3d61f30a65fe1b39c92198371fd934f4d3108d"
    sha256 cellar: :any,                 sonoma:         "74142e75635df4bd288e63fd560de54ecf95ac434a4b4e1daf4615176735b7ba"
    sha256 cellar: :any,                 ventura:        "c72dbc7af91fcaafd48d6568fa58521c0d603c8caf90c02be1efc70f5f115314"
    sha256 cellar: :any,                 monterey:       "082391bdfc923845a430fe3ccf8142af088f0bc6c0e7907fa22b902ce91df8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ec77cbeeb12f0268f6b8cad2e5717d7f97e180d0129b82bac914826b1b2c16"
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

  on_macos do
    depends_on "coreutils" # sha(1|256)sum used for ex_doc download validation
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-27.0.1/otp_doc_html_27.0.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_27.0.1.tar.gz"
    sha256 "38cd4e701800bd3a71ed3cbd2fe01d5811bbb1d76ee5279f7d765f815b7d29e1"
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
    system "./otp_build", "download_ex_doc"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

    doc.install resource("html")
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
