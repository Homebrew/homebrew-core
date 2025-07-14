class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.13/otp_src_26.2.5.13.tar.gz"
  sha256 "a02efb423a7ecdee661b3c3ad2661521d9c00c2dd866c004d95a87d486a03bab"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c048215c83ef4241295e2a0040be9d6ea36b78d33cb63ad50d3c43f047e2477d"
    sha256 cellar: :any,                 arm64_sonoma:  "14f6ea2231318f8f1ac251cd515ec6345e75d9b40aeaed11c62d74cdd8edfd64"
    sha256 cellar: :any,                 arm64_ventura: "be9720d97b3bb161167f62c68b1f49dbcfdf81a9293941777d67ae00dd85fb94"
    sha256 cellar: :any,                 sonoma:        "7a918a8a70b9c2a38a0f1ae54949fc98d0e16a180461a8545c49764dd3c04dce"
    sha256 cellar: :any,                 ventura:       "c28d4d286a225d3c4627ec904c12716f7f5524416cdd8081e0f61b83aca8ecc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a4331299da165ef8695c65f2fb187a2821cd9475f1eb5eab454873c312f853a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18366e8f248dce1615647bb9faa441c6066500071c9c383a8a2686b2aa126284"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.13/otp_doc_html_26.2.5.13.tar.gz"
    sha256 "fb7bb87b9edf88a621a97c01b436f5c3daa6a5715d02adf96031f5dd2c07edc0"

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
