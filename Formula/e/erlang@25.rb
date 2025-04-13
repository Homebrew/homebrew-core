class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.19/otp_src_25.3.2.19.tar.gz"
  sha256 "24e9b6c3dc4926619b82be4f46abdd757055fedd386f89b724f3e59573e5d1c4"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4cdfb08a9c4ecf72dc8772b746d9b44a7ac6e4da34cd8ee82eefeec49aacf303"
    sha256 cellar: :any,                 arm64_sonoma:  "f2830d91d6e07b149f1576e3b647628232eeda1bf04c32108ac31c7648f26965"
    sha256 cellar: :any,                 arm64_ventura: "870c6e83a94c631209e0a04a4ed9bfcb883a8cadef776f82dc51776f02ac3bcf"
    sha256 cellar: :any,                 sonoma:        "97c5db4e669ca976e5fb9f5ff4944dd913edf7d0a2c94faa0dd7623e99c5fcd5"
    sha256 cellar: :any,                 ventura:       "50e066fba24045aa21e3f304202a2deb416ec3af9a191b2b626ab86077fa54aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d84054fef7db000c1c21280a47fae06e96284065a6a06e72844ad4e47081a83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d5ea8df7f82c8de5ef0c482d77c5683805b39025bb7b07cb73052a23a4a42af"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.19/otp_doc_html_25.3.2.19.tar.gz"
    sha256 "8f7b2ece491212c018211e9f70e09e99b6dd978bfa58dda752c30a79bc244ff7"

    livecheck do
      formula :parent
    end
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
