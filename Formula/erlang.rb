class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.1/otp_src_25.1.tar.gz"
  sha256 "a5ea27c1e07511a84bdd869c37f5e254f198c1cecf68ee9c8fedd23010750c31"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8522b32821cb7163b63e1a7861aed7e7c627e0f40e1d08eaaae769ddc182f050"
    sha256 cellar: :any,                 arm64_big_sur:  "d2ac37f60ff03490fb0ae7eb642167e743f64e87db6090681188672bc4849bea"
    sha256 cellar: :any,                 monterey:       "d691371d81b12f23aa0ab395eb32f157d75feb43ad6d14a81437a72232da0a10"
    sha256 cellar: :any,                 big_sur:        "a9ab5f7bd0198ba726e6a08fafdb98f7f2cb3eb875ab0a8eac5e4f1c748e1894"
    sha256 cellar: :any,                 catalina:       "5ce67afa44aafc767991d0d744661fb0480551de2f548b0845f7f2c69eacf1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8d20d93d9b2d12d34f461396d9da833c3725f2b3cf93dc5da4857829b7d3501"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.1/otp_doc_html_25.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.1.tar.gz"
    sha256 "13de45e300e5de661b0d1ab33e997926e764a221c4668c0185f371c22a7f5d1b"
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
