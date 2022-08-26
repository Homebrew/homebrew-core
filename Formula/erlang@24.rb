class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.4/otp_src_24.3.4.4.tar.gz"
  sha256 "86dddc0de486acc320ed7557f12033af0b5045205290ee4926aa931b3d8b3ab2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4ce37fee3dad33a25618ab99c869f5366c28d915df643ded7c3807f609fb66e"
    sha256 cellar: :any,                 arm64_big_sur:  "e7150e8b853c826895b71ee4264ea78d6bf8286fb719d9759113a499b276e242"
    sha256 cellar: :any,                 monterey:       "f23b499a514e4f8f0e268deb6fe48cedbfa156ab18daa694de69a3c78ff799b4"
    sha256 cellar: :any,                 big_sur:        "7ad0a3d5e516c95702a2b10358f61a629c7e05214690f8e70ca545c121ddd606"
    sha256 cellar: :any,                 catalina:       "45c12fcdc6f458642cb76f984b64a84826ae8cc346eaafd285b6bca8edcb632d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2623452b08cd852dcfafd06726cb58a5d107cb731252b12c2c4b243f0d889b3f"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.4/otp_doc_html_24.3.4.4.tar.gz"
    sha256 "5d91b57274650bdb2d5a27156a20e7b82a0a476d2f150dbf5fc9e9adc553c1ef"
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
