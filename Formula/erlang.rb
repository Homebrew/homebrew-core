class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.3/otp_src_24.3.3.tar.gz"
  sha256 "cc3177f765c6a2b018e9a80c30bd3eac9a1f1d4c2690bb10557b384a9a63ae8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "298e0a5cc74018d38d8a5d9312c37093f75ce7410f9d30300bc4c492e8ac68f0"
    sha256 cellar: :any,                 arm64_big_sur:  "2f9e33eb566631f7b3218352c4cb48610ba43653d68d84df8ab25e6a1af950b2"
    sha256 cellar: :any,                 monterey:       "5367ab804cda864fd28b55f1a3d44fe93d7ffb4096e3eebd5c65564ec181885b"
    sha256 cellar: :any,                 big_sur:        "dce158134b12212751356f95316c739014fcf44ebcd2a43ba5c97124271642d5"
    sha256 cellar: :any,                 catalina:       "ba13306d5dbddb9f1d9c3b0d81f8342a7e5480bcccc465c76d7ad2019a392375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc4f745ebe0297999c6666c3a4f117ddc0f8cab9870d24985d4ca4d0e47de16c"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.3/otp_doc_html_24.3.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.3.3.tar.gz"
    sha256 "a555923a0360cf1acd9c440216a06be7cc663ce0a067966600142d16f9e99bbb"
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
