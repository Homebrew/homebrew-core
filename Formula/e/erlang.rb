class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.0.2/otp_src_26.0.2.tar.gz"
  sha256 "47853ea9230643a0a31004433f07a71c1b92d6e0094534f629e3b75dbc62f193"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ee0488d6c6f9574863eca164216cbec4fa257719718dc8726e1e8300aff30d96"
    sha256 cellar: :any,                 arm64_ventura:  "7d2356aa4fc680bdc92e59c07ac12cb5b8755561a62ca9f3842997cc92af0eb9"
    sha256 cellar: :any,                 arm64_monterey: "311a26c77e74404551764f71e50cc4c81f476d6f519f1ed11045b26fa5efbd83"
    sha256 cellar: :any,                 arm64_big_sur:  "eca8d2f0062845449f74c8570e12fd512c25eb41d521e80a6759eef9bbc35b90"
    sha256 cellar: :any,                 sonoma:         "b124bca8fbe5c28ac24ff1e1a5cb622779cd9872b336aab39165b7a093376af9"
    sha256 cellar: :any,                 ventura:        "10369e72c47c8732d799968b39bb9f4fb172d7a81b728d0940158dbaccb00026"
    sha256 cellar: :any,                 monterey:       "3d8001af6fe8a4e966b05260324b6596dcc1ebd4d0655050faf9af429afe6706"
    sha256 cellar: :any,                 big_sur:        "9f95193544d0ba84a614634605e24f6810b04a717cf387482ffc3a55bb56af67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30fadde080ea2e476b7e5428e80c0cd4c41a6773f1e62c9f9e80e7f97efeaf7"
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

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.0.2/otp_doc_html_26.0.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_26.0.2.tar.gz"
    sha256 "f071d8af459a5294fdafc379f36e40f37d05fbea06a676a4913549a25f799f64"
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
