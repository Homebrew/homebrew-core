class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.11/otp_src_25.3.2.11.tar.gz"
  sha256 "64e4569615fc4ba9fa95664a18a5336e2c6363534b9eb131f08b377a5c176ede"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3073af7e0261bd3be4174ca43eac39f4e2f47dbbaca281c1316cbdd8336faf13"
    sha256 cellar: :any,                 arm64_ventura:  "9a7863cf91598e729efa5416f2b6128931d2ad5a8d69022264b6a7c040644e1e"
    sha256 cellar: :any,                 arm64_monterey: "bc7ce68d91b09a91fe982b29740f6e8dab96203b0d3ffaf2e640aa7f42295e52"
    sha256 cellar: :any,                 sonoma:         "5b82d2f7f88bf9401ba63176d296692dc1a6cdd99f0ec5f3cc115df6a4b51c4b"
    sha256 cellar: :any,                 ventura:        "268bc9d6a2de229047fb845e45576f2cea079513fccbfba28a3344aef5b14ba5"
    sha256 cellar: :any,                 monterey:       "97261142fa0603da77a99e0ffa79e8f20e9d4aaaacf7a3736dd58767b585a7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981de3bc09eeda61b0b6656580dfd2be2d161a99f337fa4668cf4433d48a79b5"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.11/otp_doc_html_25.3.2.11.tar.gz"
    sha256 "1f51aa5aede20c7a2a7a747632142750af579135163f4d59381ca4b215c3b138"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

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
