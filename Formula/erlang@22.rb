class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.22/otp_src_22.3.4.22.tar.gz"
  sha256 "e7f0793e62f8da4f7551dc9c1c0de76c40f19773ba516121fc56315c840f60cc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99fbc19c45f5c506f0d709159bcf98a32d2784fa167da8619e55ed781936a26a"
    sha256 cellar: :any,                 arm64_big_sur:  "8003b927236a6a4a0048b42bfa1082c3cef56dc435d2aaf24bb2935680e8c6e0"
    sha256 cellar: :any,                 monterey:       "6a1d2b175618d6c6e367e33f107ddde081aec9a13534acc5b884f669b148be40"
    sha256 cellar: :any,                 big_sur:        "3c6231a52f643ef4d2aadb45291b50c0316eeaef0b6917c7db18a6217bf74e12"
    sha256 cellar: :any,                 catalina:       "cc83864d045e44a185a4f88badffef56c85898ed4a2a45654056c55a8477ab0b"
    sha256 cellar: :any,                 mojave:         "f6cfeb11ec3f61d934c6a8cd6a91fbb9e1aec7f4ca1d46883c353e9bcd8b362a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3bb9240f26fa3c615f383e83371b216210ddf590b232ab6b5f214f0611bafb"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.3.tar.gz"
    sha256 "43b6d62d9595e1dc51946d55c9528c706c5ae753876b9bf29303b7d11a7ccb16"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.3.tar.gz"
    sha256 "9b01c61f2898235e7f6643c66215d6419f8706c8fdd7c3e0123e68960a388c34"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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
