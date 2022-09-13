class EmqxErlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/emqx/otp/archive/refs/tags/OTP-24.3.4.2-1.tar.gz"
  sha256 "0ae423723b7d0d10b4779ecbe890dc297ff05f5e97b02da68488ca8e53dc1bea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+-?.*)$/i)
  end

  head do
    url "https://github.com/emqx/otp.git", branch: "emqx-OTP-23.2.7.2"
  end

  depends_on "autoconf"    => :build
  depends_on "automake"    => :build
  depends_on "coreutils"   => :build
  depends_on "freetds"     => :build
  depends_on "libtool"     => :build
  depends_on "openssl@1.1" => :build
  depends_on "unixodbc"    => :build

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-silent-rules
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
      args << "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
      args << "--disable-dynamic-ssl-lib"
      args << "--disable-hipe"
      args << "--disable-jit"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    ENV.deparallelize { system "make", "install-docs" }
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
