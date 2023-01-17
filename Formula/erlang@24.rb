class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.8/otp_src_24.3.4.8.tar.gz"
  sha256 "3d8ca72146cc08f1084e4e0fcaec31621108fd88ad1368f01dae3b8fb628e859"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95a61a6d9775e0a34a05449aa5c84a9af64468e9307b50e041ef76abbe60e1de"
    sha256 cellar: :any,                 arm64_monterey: "0b79716503b8e0eaba752289130cd6b566d573af1e0c7c6b93d0a4d1bff205c4"
    sha256 cellar: :any,                 arm64_big_sur:  "e3525040c224747772f9ee6ca1e8247f280130978b148784202cbca0db086b76"
    sha256 cellar: :any,                 ventura:        "32108432abc51e58d8c36f85caf36b9196ddc54f59f8037b2c8d511601e5a299"
    sha256 cellar: :any,                 monterey:       "b99eea108f42764a82659218ce7604d2366eb8c87c5e736987f25d48b4f988c4"
    sha256 cellar: :any,                 big_sur:        "9c6fe58485a631a29eade337aed7d6278160ee33cae8a3f2e10847b0d1450930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f1ec0a3644e568c4f2a1775aa60ded4a67dee21dd80a90f8cb02320067a057"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.8/otp_doc_html_24.3.4.8.tar.gz"
    sha256 "0627f8efc6566d579c3e7107307b663cb955e4d194ce05aae68a8f1f2dddc01f"
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
