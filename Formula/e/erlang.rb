class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-28.0.1/otp_src_28.0.1.tar.gz"
  sha256 "a1d26330e3089d4d70a752210f8794385e8844e3d19684835810f1a59a752158"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "490db99377182363086a83280c3b7044b2eb55e766bcea79132c18666c2b9a91"
    sha256 cellar: :any,                 arm64_sonoma:  "c49914e4bf00672ad90b76d5f605801c84efdbfb0472a5bbd1eeb9e0268351af"
    sha256 cellar: :any,                 arm64_ventura: "fce1294a40760b2e05f287c6106508227b18c57ea028a0497eb9b4be8adf6a1b"
    sha256 cellar: :any,                 sonoma:        "befd96973b99054c62bfc59d575982e84ecc4c4ae21f9f419db5ca238a41c220"
    sha256 cellar: :any,                 ventura:       "e3d86be194e7774b7a141fbf4d4e2a2e97e75709be890bdb65aed9580da3c0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f801223f721c5aa92511f2bad33e98a7c33fc3218392c5fcd9e153e152a506c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e310df03ca1249808809b70dc98224fc4158b67db995e89cf4f9e3e62eb33d1"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

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
    url "https://github.com/erlang/otp/releases/download/OTP-28.0.1/otp_doc_html_28.0.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_28.0.1.tar.gz"
    sha256 "2a391d8d9ab46a0bb5ffbd1181a1d471da9aee7066ae94a7133ea4b378df72ee"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.38.1/ex_doc_otp_27"
    sha256 "4aaafd13d056aeeca8b23a016b330114947c8d33ea657c22f637259e626e701e"
  end

  def install
    ex_doc_url = (buildpath/"make/ex_doc_link").read.strip
    odie "`ex_doc` resource needs updating!" if ex_doc_url != resource("ex_doc").url
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
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
    resource("ex_doc").stage do |r|
      (buildpath/"bin").install File.basename(r.url) => "ex_doc"
    end
    chmod "+x", "bin/ex_doc"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "install-docs", "DOC_TARGETS=chunks man" }

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
