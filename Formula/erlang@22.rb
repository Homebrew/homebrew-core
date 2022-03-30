class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_src_22.3.4.25.tar.gz"
  sha256 "f1e94f0b66fae1f48f4fae45480ba5c7d15a3bae0aac8d1b580a41cf0eddfd9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1ddc19ec9f5d05bc4ce353695bfff6bfbe87b72dcfb67d156a904f4d1f290441"
    sha256 cellar: :any,                 arm64_big_sur:  "3ac8c19abd1acf42258d796a73e022ef39591a7d6994bf610ffbc6f7af91ea50"
    sha256 cellar: :any,                 monterey:       "3f1d624a0eb6d44e6afb8a4314d302b81ecdbfaeeb61dff57ce913ecbe4b8570"
    sha256 cellar: :any,                 big_sur:        "c455c6b165d8b584fa4eb770e0cf20c64eb94f2ad0e69b01a0f95ac737d1cc70"
    sha256 cellar: :any,                 catalina:       "b782227fbb163e41caa5796f4c81308f599a011048b86c80fb0b100985d5efd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7a9552e79564ddeea2a1695a3c58febc0e836cfc2b7f41a47b65acfccde280"
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
