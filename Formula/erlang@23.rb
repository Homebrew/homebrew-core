class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.17/otp_src_23.3.4.17.tar.gz"
  sha256 "9e45974c2a44b929ded178b05e4e14a6eb34592f025957b38c7b093a67feda0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "db61d079315cdea09eb8adac1a57dd410fbc87af80699970e964003fccb21b9e"
    sha256 cellar: :any,                 arm64_big_sur:  "fdcaec9c6c59bf4744b961c2e473de210fc9905029d9f882733daae7fda484c1"
    sha256 cellar: :any,                 monterey:       "de1bb45fc23ce19bcd0b2ecbd1fc1212237bc734542fb37f714c4437c2102534"
    sha256 cellar: :any,                 big_sur:        "088b757ec2aaa3d61c1f523ec1da405a331f8c3545edd9e6827d049582fc8cd8"
    sha256 cellar: :any,                 catalina:       "349694fe455638e078fce42994d1f1ef22855b1843c06364c04f489effb3335f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f865f9b8ac9ee523b0035e982f5a5e1cbd55c27d9db0de42b115b8a48053e3c3"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.17/otp_doc_html_23.3.4.17.tar.gz"
    sha256 "0846cf776f13decb8e10e2b28b1c07e23f53263351c07092f3778d1eec896edc"
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
