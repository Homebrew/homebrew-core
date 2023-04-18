class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.18/otp_src_23.3.4.18.tar.gz"
  sha256 "fde15701e97cce3a036108ead20409c87a81c6ad3421ece5b66bd4d26dcb1cb7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "9d9a43ab7b541905c9c49495fa3a47c4a6b52fc19bfb218e12abfabbb2186b17"
    sha256 cellar: :any,                 arm64_monterey: "2b1dae3630c5b14c2ffebb12c51e1cf91ca52969f8c7f0fd1479e29f1b43de00"
    sha256 cellar: :any,                 arm64_big_sur:  "4258e12b10fed77f694c7ddfa52fd2af15817b9dc2dbb0fd2187b7c5b388df83"
    sha256 cellar: :any,                 ventura:        "b1f89d9e2a8beb5a37f4d453dcf15670de01e5e1b25747c7b0a3b4937169faf6"
    sha256 cellar: :any,                 monterey:       "a3d3b5609b1035ef2d8c4a6933aa6e80c784fb59a9b4c8b0f340ff680ecf8571"
    sha256 cellar: :any,                 big_sur:        "3ab52ba5f02fa37d4f27dbae09c4fb2bcaa28bb8c313f019883d4a867e877916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dfe079ec780373e8c97fb7f3deef1c77a6b71d3c89c9fa959a2a267ce7cad9e"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.18/otp_doc_html_23.3.4.18.tar.gz"
    sha256 "61e09ef289fe3cc77ca43c0be0d7bd377650f8442d825ea833ff2758d703d998"
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
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
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
