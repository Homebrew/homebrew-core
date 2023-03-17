class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.10/otp_src_24.3.4.10.tar.gz"
  sha256 "18a58b889b62dceb7ad0d2904c02edcd66f8971e46d6a86cfc296f9f5155ffd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "145db8a44cbb333736b1553b253467716112d4e1ba4955166ff04fa23691e7ba"
    sha256 cellar: :any,                 arm64_monterey: "17dd0ac3baa2ed341c383164123385646e64f33ca8adb05719b3f4b56e90f2a8"
    sha256 cellar: :any,                 arm64_big_sur:  "d7597fcfa43c6710172b36b0be9b360d2ab78320d2dd3cd2a374e2ad408c1f97"
    sha256 cellar: :any,                 ventura:        "c089a3129981b70deb975eace80e7fd6763ddf712af75b2946f7cd74b6e81a57"
    sha256 cellar: :any,                 monterey:       "8fd8b79ec54a70c893f908bcc5afc76b5e3ae703afcdc4b71d64bd7e39fa229f"
    sha256 cellar: :any,                 big_sur:        "6a02117f5968710111d4b4f83eac4903edb963fa1f43e735ac4a1e63bb924233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de3b48ac88ed4f0d1e04d3ee4f50ff6d2acfb033b2c708c966a21de696c7f926"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.10/otp_doc_html_24.3.4.10.tar.gz"
    sha256 "bd25a9727adb1fc688a4c516f65d27be551af5718c039c1a36475b11ac8a0e0a"
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
