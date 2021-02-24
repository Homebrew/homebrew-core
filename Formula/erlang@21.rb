class ErlangAT21 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.3.8.20.tar.gz"
  sha256 "7ed3b3c149add9f847144d507ffc411d63a212523539789e9d73d19edcf5aa16"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(21(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "6bb8d0a516d32ed5b0d35f38a7fa42847b65a36ce1dfb561f198b43a80add84d"
    sha256 cellar: :any, catalina: "bb684a65ce01740ed9005347f3a4eb67b48fd2300ba5abd648a6bf0288dc89b1"
    sha256 cellar: :any, mojave:   "20e0f6b00c8c4b5bf9dbd71a245fa1e9b900a20255079c7a0a2b17b6136d1294"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_21.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_21.3.tar.gz"
    sha256 "f5464b5c8368aa40c175a5908b44b6d9670dbd01ba7a1eef1b366c7dc36ba172"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_21.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_21.3.tar.gz"
    sha256 "258b1e0ed1d07abbf08938f62c845450e90a32ec542e94455e5d5b7c333da362"
  end

  # Fix build on Xcode 11.4+ (https://bugs.erlang.org/browse/ERL-1205)
  patch do
    url "https://github.com/erlang/otp/commit/3edba0dad391431cbadad44a8bd15c75254fc239.patch?full_index=1"
    sha256 "0c82d9f3bdb668ba78025988c9447bebe91a2f6bb00daa7f0ae7bd1916cd9bfd"
  end

  # Fix build on Xcode 12+ (https://bugs.erlang.org/browse/ERL-1306)
  patch do
    url "https://github.com/erlang/otp/commit/388622e9b626039c1e403b4952c2c905af364a96.patch?full_index=1"
    sha256 "85d3611fc071f06d421b9c7fae00b656fde054586bf69551aec38930d4086780"
  end

  # Fix build on Big Sur (https://github.com/erlang/otp/pull/4524)
  patch do
    url "https://github.com/erlang/otp/commit/99fc87254e07fbd7bf4f9a02966a455846d5d017.patch?full_index=1"
    sha256 "8a9b91f428f779e76d4ed85af1a079fd6b54bd9fc6d4d45fc2747f8a4fcac0cf"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    on_macos do
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
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
