class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.19/otp_src_22.3.4.19.tar.gz"
  sha256 "be07b423e4be9ccfdae67f566595ddb55510dd10d2e65586497a730809803f30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c4a3d042000ec10f0f86463602c4b00f165a64a00180475fb83dcfdf19aaa842"
    sha256 cellar: :any, big_sur:       "dc58d129adb121c63fa91e303799750d5fa559d9852b985ff1dba572337c6f66"
    sha256 cellar: :any, catalina:      "c6a85486eba7395025c29fcc0b86a4b785719af103fba59eab03839a31ca6b1c"
    sha256 cellar: :any, mojave:        "0e28838e3dd1c5b33586c2a90905d849e9ca210814bcbda696a6b15076dea7d0"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

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
