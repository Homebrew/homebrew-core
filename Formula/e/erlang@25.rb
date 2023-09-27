class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.6/otp_src_25.3.2.6.tar.gz"
  sha256 "14f519bb63f9cc8d1db62ef7c58abc56fa94f8f76d918d23acad374f38434088"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6aec05bd1b74ec79f87f614c44a0eafe0f57801d1204bc488b5c970da8d875d4"
    sha256 cellar: :any,                 arm64_ventura:  "e85ccb61b541a57d7d59c64c1154d61fb34f0db4dad756bae3e2166b7551183d"
    sha256 cellar: :any,                 arm64_monterey: "fb0b50c4b8a2cbdb1d7da017778441dc5d4f2a28f445e2a736184409d29a7b98"
    sha256 cellar: :any,                 arm64_big_sur:  "bfaf67f49cfa58a5b18222efd765ea7043e7d5d0764fcd7078eda07ed0866b66"
    sha256 cellar: :any,                 sonoma:         "36e50e43a02dc75bbc26e2ed1b46081d77f59a7ac215a99323673949b295f5ba"
    sha256 cellar: :any,                 ventura:        "9b1739938cabe69579e0d3afc3516bbb2f60ee9584d0229f2890fcf4c4bf8abf"
    sha256 cellar: :any,                 monterey:       "a31be924ee1d81d65ce41c1581fe262fab7e278dc0224dd55e6a5d6d9d5478fa"
    sha256 cellar: :any,                 big_sur:        "56e395c46f65b9c3fdab13b6569325e12cfbe0c64d6c042fb04d9a8fbe7a7a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7b330a42d26870d119a955b09655f2cb51898b1d21ad2186b6d29aba3a58c1"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.6/otp_doc_html_25.3.2.6.tar.gz"
    sha256 "b7c7f2a8a4c9cb84e4e7f86645b1ffb5a7cff57f712c5a1cb1a7056692ac7184"
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
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--disable-jit" if MacOS.version == :sonoma && Hardware::CPU.arm?
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
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
