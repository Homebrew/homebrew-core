class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.6/otp_src_24.3.4.6.tar.gz"
  sha256 "8444ff9abe23aea268adbb95463561fc222c965052d35d7c950b17be01c3ad82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7273be648fb66da6e16c14401718c55d4dce5036255f1a1c9332aadf4094eac3"
    sha256 cellar: :any,                 arm64_monterey: "7204baf7dfac19528154a198740865287309c6a49747035f6b2882bdf1faa3f3"
    sha256 cellar: :any,                 arm64_big_sur:  "748164a050aad8cda86ecd8e09298e1c4a938139a765b69a8966fb6380e47a81"
    sha256 cellar: :any,                 ventura:        "3cc93a7d95f27cf4dcccf1e0b08daef94e9a833b782b2f52738881c26d799d40"
    sha256 cellar: :any,                 monterey:       "27c7839fb92e8a2b632389b421b853e9a056f026154d9f89536f6f47e81d6853"
    sha256 cellar: :any,                 big_sur:        "02e174dae9ddfad29b4e15018d553bc01653999ed616fe98b9b51f0d3f35ac14"
    sha256 cellar: :any,                 catalina:       "1bccce2c64fa688445d3494f08cb187925023912f67453fa8a98e65d8cbff0ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c7900632db360ab713df778ac0d8db276428c0989ed1908f1b04e279cacb6f"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.6/otp_doc_html_24.3.4.6.tar.gz"
    sha256 "5122c6d298624244e83dfc82fa2f8260acf67d3c895af93a66f23558a8e7b64e"
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
