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
    sha256 cellar: :any,                 arm64_monterey: "38448ebb0c645e8d9779397779bee3247026af5c183821b1d1ce716be854a5aa"
    sha256 cellar: :any,                 arm64_big_sur:  "2314b8dd30f47b8cf38a4dcb62baaddbed3c5f98bf817478842423e3166eaada"
    sha256 cellar: :any,                 monterey:       "bc4b810f408cb78251675728b3eae68196d51d82d5d9391fa7bc580d91c563f3"
    sha256 cellar: :any,                 big_sur:        "353a7ddc38f0f1efbab4847792ed2f4ac4b1cddbb899c11c86eeb968859ec98e"
    sha256 cellar: :any,                 catalina:       "b35d03ab317f9c1feb07fe0dd686b004557f663b828d147d8a72e346cc56c8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f95df4665e78f05819703019d674d0141a3a7c089462feb89610b7242fa62f"
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
