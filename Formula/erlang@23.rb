class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.15/otp_src_23.3.4.15.tar.gz"
  sha256 "16a82292e14de16943825936e17d9b71e2875a89717596f4023e5a03bf20e6ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "25f656d79daa5356da81be19f6b6a9cce5c255c19d760e6846fe30eceead6726"
    sha256 cellar: :any,                 arm64_big_sur:  "b20982643ad3fba40cfb3b076e81e796b6a8db6d81e4cfe7d3620075c04ac341"
    sha256 cellar: :any,                 monterey:       "9c50ceecdf5aafc7f8f189aac800af725241bf595c4cab786b3d87af6bee5fb0"
    sha256 cellar: :any,                 big_sur:        "e95e6b9f82e4de0a9e7678af4967d2bf24f7a627f440b53dd732f42c2c5e237e"
    sha256 cellar: :any,                 catalina:       "8c7d8d622b98ef380e7df32ae435d6c8f08731fa12934da07468f77533af2d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636ecffbc17eee919aa8b0b73801d4d4b0a2fa2178368efd05ad69fddd8a5980"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.15/otp_doc_html_23.3.4.15.tar.gz"
    sha256 "df4cab04b2cac0362de4fa7e7f0ac69d38c75579fb0f034bd4bf99567b72d5b3"
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
