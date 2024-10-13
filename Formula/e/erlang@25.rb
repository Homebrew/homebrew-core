class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.14/otp_src_25.3.2.14.tar.gz"
  sha256 "99fc586af28552efc097e37ee7c779ee5d954225ce4ff45eaa66622a711dce6a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6642ab5dfbe85072b4b0e963b738b3260c66d59ed29adfd945af8d51cd9ad1a4"
    sha256 cellar: :any,                 arm64_sonoma:  "4a70722bdd89a48a847265544d55b86298c24298aee1142dd0a2025cda4e69ab"
    sha256 cellar: :any,                 arm64_ventura: "30b00960f96c396b23711984db8ae164028541cb4fedc2af79ddc5cdc335abe4"
    sha256 cellar: :any,                 sonoma:        "a60a2b2fa2dbb16f78061e7becad5e33a4f381fa096f2770ab51583571415b54"
    sha256 cellar: :any,                 ventura:       "84f95615189e3a8f75d0e4d3ee5e3f7ecf901346d84c6f1f509c7e469ef51524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9121b623978c5953a75066db519d6800cbdc3703e37386de3aac0dfe361cc497"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.14/otp_doc_html_25.3.2.14.tar.gz"
    sha256 "b9a50c9cc61b45e11e58bba4a5f40f9b3dc4c95c799d792fca7d0655e511dd1f"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

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
    system bin/"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

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
