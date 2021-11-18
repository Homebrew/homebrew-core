class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.23/otp_src_22.3.4.23.tar.gz"
  sha256 "561b9c1837db6c4f65585fcb5e3030b58710da52d1734bf2a75c1e42bff11002"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d91d681d7db3d029915b9ff7f2cad353a5af2c563bf0b322b698915617ae5b4e"
    sha256 cellar: :any,                 arm64_big_sur:  "259d69c524dbf650fc7afd61cd6f52f61e6c55c57922b4a75f19169b3c12ce2f"
    sha256 cellar: :any,                 monterey:       "ab399412ddb94cf18d9449b1c5e9bb83761873fbb811b59e9792f39f098a0841"
    sha256 cellar: :any,                 big_sur:        "5d9d0ef219808032b6fc880b81759524609d121f79fdd1faa68b15a55bc27bf2"
    sha256 cellar: :any,                 catalina:       "411027623297220016d47e033b6bbe0bf68dff127a44a05fd96948d761b167fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c1f893160c9141a44929cd8d7c40fcb83005d0e0652bf0ee8bb29d77c565b8"
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
