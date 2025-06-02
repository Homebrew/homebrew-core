class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.21/otp_src_25.3.2.21.tar.gz"
  sha256 "99296fcd97a2053c5fcde7dc0ded2ba261a3baf1491c745fca71bd9804d51443"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65fde55b66db90156d6709104d43a2b599c79fba2c9f3cfd39baedefeb3e3d3d"
    sha256 cellar: :any,                 arm64_sonoma:  "e120e61ccdbd483edfef22a3829794350da15a96dd71389d5478a33ac496a7ca"
    sha256 cellar: :any,                 arm64_ventura: "12280e821f8d50701ed2ce4bf23011fd5199d7ce716a7da6a97384573c019976"
    sha256 cellar: :any,                 sonoma:        "ec11109a563a4d97aa616bf896297de7cb2973ea2e02979b44eaa4d5f2949863"
    sha256 cellar: :any,                 ventura:       "458d3a1961ba7dfa73cd953deb1ec4726e4926b85d94f5536322bb2be9fb54cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf9cbe47cc7192af68089444a4b92203355ef1f0b963ea3568a9acdca8a77813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8d50b3f4b3cf6413965b73065c4b512cf2b8461e0a6752501854f6518d8a09"
  end

  keg_only :versioned_formula

  # EOL with OTP-28 release (2025-05-17)
  deprecate! date: "2025-05-26", because: :unsupported
  disable! date: "2025-08-26", because: :unsupported

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
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.21/otp_doc_html_25.3.2.21.tar.gz"
    sha256 "686fde552fec0cac7a4a100320a1dc82b15e57c663c3c726b3f292f2abfd7e18"

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
