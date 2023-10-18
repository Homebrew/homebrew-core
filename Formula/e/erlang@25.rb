class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.7/otp_src_25.3.2.7.tar.gz"
  sha256 "a8662859d153d3c4253c6a3a4d1538d0f32ce1cf02bb5484b17c9c176da37b37"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3d037c80bf3f7b44238cccb732b48fa1a24ee7e061d431ef8cc59ef3e898a9a"
    sha256 cellar: :any,                 arm64_ventura:  "e628b540f206df6e58baa1037406fbc9cd7838b8372d959c395fdf9ca4b07d11"
    sha256 cellar: :any,                 arm64_monterey: "0d8d79411b04aeaa2f9fbdb34fd6afc9d6dc0ef13c7903329bd83115b5417db5"
    sha256 cellar: :any,                 sonoma:         "e3a643da94fae147baacc97802497fb7db1be4cd628c919b5dca778fd7e61311"
    sha256 cellar: :any,                 ventura:        "d5a08cb819390ba36e8c44aacefbdcff23a1064e58f54690de299e9dbcf8ed21"
    sha256 cellar: :any,                 monterey:       "b33bddff8298eb03fd6befda1cb3a24effc78024cfa6fc37b05eedf6e668f9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700fd249a2e9ab4e5cb8788c686b0fff0d66e8f62c374de82e73ea235709e695"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.7/otp_doc_html_25.3.2.7.tar.gz"
    sha256 "7c510198f1d777dc428566af03dcbcce12746e8a38b242a38e3408a19d2f3eba"
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
    assert_equal version, resource("html").version, "`html` resource needs updating!"

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
