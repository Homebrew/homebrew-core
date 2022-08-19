class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.3/otp_src_24.3.4.3.tar.gz"
  sha256 "1f80c90a973863622b66f6b590508473c173c9bd267fadb6d5b6e0657caec861"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "31d3f69d38b865b7f4bba5f8b7336940a21237cb68e7f29cfcd6330084663621"
    sha256 cellar: :any,                 arm64_big_sur:  "8eabf512227eb38d00d9520b7f1cbca833fdd68096fd495bb49a800fa72a2850"
    sha256 cellar: :any,                 monterey:       "ad9905e5925ee127acc7cb7a84adfa3c2f4d8d46069dee1c3208ecd4b8621cc8"
    sha256 cellar: :any,                 big_sur:        "fee9877521d40fcb005a9faa3eb0a363d5f8bda8b8b0cc905549f29e24e9eca2"
    sha256 cellar: :any,                 catalina:       "924a4e65f35f902e6609e41d4589494c8bdd41b58afad1baf984979ed89da177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ba3a50ba910499bb533319c6ed1f2980e6498386121b576df8fe6c5da5d45e"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.3/otp_doc_html_24.3.4.3.tar.gz"
    sha256 "4655cd8211303c08996310cdf89b5198bf7850b5245d6e808b478aa3a90a4257"
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
