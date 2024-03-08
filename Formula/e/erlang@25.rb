class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.9/otp_src_25.3.2.9.tar.gz"
  sha256 "b305190e01e84eddb26d0140637f26adf674c87351c679f3bbefc8685d22cc05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "777c56baa94033fefe0aa3340d025e630e1e7a173efb4f2ff37de9c490314b7f"
    sha256 cellar: :any,                 arm64_ventura:  "5dec2eb68560a5c543f840bff803e17594f7eb846c2c91ec91a5c34184a2c1f7"
    sha256 cellar: :any,                 arm64_monterey: "74c5f3eb257f7fe9fc9fa9defdb17b6e062a1b00bdf2c7580199fb8093d7b7e2"
    sha256 cellar: :any,                 sonoma:         "5d4649c231fee46bd27d06dc42f242cedb7994f0f6ecedec5648f8a98ea55958"
    sha256 cellar: :any,                 ventura:        "2e8f08d2d8b92ad7f0b235d84e94de882f9df905c923d77f37021a5195d2b644"
    sha256 cellar: :any,                 monterey:       "b243ec1c6abdf04700ab26204fe37846df833b0c0a59af357987e85c7e127dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b445ae77eff6f6f4fbef59db89c352ec88a8f09c9c89ca538eec8773c822a4"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.9/otp_doc_html_25.3.2.9.tar.gz"
    sha256 "fa547054879f0910ee34a3fe8dfcf06b1716160a6a853d83aafb2509f4ff36a2"
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
