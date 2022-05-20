class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_src_24.3.4.tar.gz"
  sha256 "76fcca5ba6f11eb9caac32bf053badc46b5d66f867150eef077f4f0d7944ecd7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bb51d8c8bf4493072bf0f5cb3db4d59086a7d380cbedcf89ac89b24134d8fd3a"
    sha256 cellar: :any,                 arm64_big_sur:  "d17a2f20523cb1d2ab2264f70ad43cbd9d1ec3df4eb2c3f7b5a8677ee063dd2b"
    sha256 cellar: :any,                 monterey:       "e0b90dcbc20550dc1a5cfa6431a06bd410a4c7c5560390f4c41c65fb583aed6e"
    sha256 cellar: :any,                 big_sur:        "7857a8d61a99894f753562c564447551713e18e93cb3d7b7db54277dddc280e0"
    sha256 cellar: :any,                 catalina:       "7dbea283c1fa2b57877c9cb9aa2e4579e00781077f3d0f8188ce04d6c552726b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0414b05c8d6fd4f59934abd0b001f27f0779c210a53419103e460f5a2f309b"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_doc_html_24.3.4.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.3.4.tar.gz"
    sha256 "06ccc6e0eed46ea92557eb8fa8ad8edb7cc330a5fba0b520cce37c7275b95d84"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
    system "make", "docs", "DOC_TARGETS=chunks"
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
