class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.8/otp_src_25.3.2.8.tar.gz"
  sha256 "9424d7713b361c8a24690515acbd7e0fd37b67d54cad1e1e4af146eae0e335d3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8064f29f8316322ac67cf408a56ab68acf2dae910bd0384dabd1b6f9e6374a9"
    sha256 cellar: :any,                 arm64_ventura:  "0b6da6b2b7357436d68ca2fdf36da274aa8530b675ea9e3d1e54ebcbccbc9dd1"
    sha256 cellar: :any,                 arm64_monterey: "094341356cc562f8bfb92e11ced5c8f5134ec9c5fb08a6eed43ddc2f38538671"
    sha256 cellar: :any,                 sonoma:         "e3f9ca0a4cc0c9cd235f88ae6116817977d2692bedb8baa2b244355df84a2050"
    sha256 cellar: :any,                 ventura:        "574f11ee71f6e15fc2f5be34cd55635f60c29bd2f2fa72b6a1c90a5d5fee5991"
    sha256 cellar: :any,                 monterey:       "23724be6ffcb8c2d45f1bfd404e4aa772e3fc920ee2d0b2ac6eadd115e1174c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255b36118c12f5ef4aaed5f40fe63ad36f9aa46b8cbb899759b98dfa29f0365e"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.8/otp_doc_html_25.3.2.8.tar.gz"
    sha256 "8b36ecba212bbad434080b5d2e8a426de7327423179998f2f53f99fea5ab6f15"
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
