class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.0/otp_src_25.0.tar.gz"
  sha256 "2d7678c9bc6fcf3a1242c4d1c3864855d85e73ade792cd80adb8a9f379996711"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67149e819c7dcad4c51dbf88d1a2b523482d17dc3864e600d777c8646edcd3fb"
    sha256 cellar: :any,                 arm64_big_sur:  "4a2454f48c932cde6dddff467fe4c16aeccc2087e540c8e98e2d3d8ab48c5dec"
    sha256 cellar: :any,                 monterey:       "011ce3687fb02a563ac3ff6736823a7afb04af4252f0898d4602da90dcfd3c3a"
    sha256 cellar: :any,                 big_sur:        "a830245019787315737928493accc24a9821fc5dfe36a993421f9053ac3910cb"
    sha256 cellar: :any,                 catalina:       "aad93de7d83259dfa53c041795d2646b792c09a07d5bba8d3e0c8b97760b3485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367ee4b67bea07c0a2fe32bde64a640f7699a3bf1dcb481828db6099f591e645"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.0/otp_doc_html_25.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.0.tar.gz"
    sha256 "2c5a7a3916ea619ec385985cd6df51a3e307aabfa09dda8283510ae013a0ca9e"
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
