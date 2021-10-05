class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.1.2/otp_src_24.1.2.tar.gz"
  sha256 "afc227a258ac061474cdffb001b3b03e77d39d5b91c56d9f589f451b9f17a3c5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "35ee937da1a3bcb38d6ab1781ea15649e62d42011eae03874125f6e33992f75b"
    sha256 cellar: :any,                 big_sur:       "e22bcb4943bb485924d5f18fc4025b7b67f441772226040b79724232837e2296"
    sha256 cellar: :any,                 catalina:      "72b0db6660854bc759d896254d2ef3279d978760a072a82d85f871bafa3914b3"
    sha256 cellar: :any,                 mojave:        "16b6c4bfc2f1f6f674420a56263d548c35b9a7553e1f81113dc250ab59e86126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94a39828395d45190658f9b280269d928c2dcf711d75c64542ca45d027b337b7"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.1.2/otp_doc_html_24.1.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.1.2.tar.gz"
    sha256 "6e3ba1672a6c70f0a9c3920d8b1f217bd113bd6039344b2d774c52a4d1c80fb4"
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
