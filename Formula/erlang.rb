class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3/otp_src_24.3.tar.gz"
  sha256 "ee8dd101af68ba175deec1844059ed287a22f7f46e72915631c965cc8be331f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a699e3481f325de59f991ab3bc1ef80ee2dc7f113de214e3104d5ce9da2b8b11"
    sha256 cellar: :any,                 arm64_big_sur:  "a3d3d7ec9baca0d1ba48352f7a29d6d978e3a0870936ac37f2fdc01b5095fac5"
    sha256 cellar: :any,                 monterey:       "f6f4380f4df350338c049b6679489eeb97a91c9d51f75c8b209f66fc6ecf2b12"
    sha256 cellar: :any,                 big_sur:        "13d6161973d4d35a1d3e624140ff8f9d377d736cfa48cf8a80336f2dcd629cf6"
    sha256 cellar: :any,                 catalina:       "e82e4c2fc995b4c372f68e9c70456999a0c52ea87cfff389d349454f2e6a4b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71740bfcb9574d9d401c400f66915c95817fc0a5c978d158e6762be1abc50c11"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.3/otp_doc_html_24.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.3.tar.gz"
    sha256 "7a247113a0f90514aacb0656e98a1e4d63e2ebf4ac9981002d046599147dc177"
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
    system "make", "install-docs"

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
