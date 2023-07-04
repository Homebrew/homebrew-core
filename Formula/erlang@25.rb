class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.3/otp_src_25.3.2.3.tar.gz"
  sha256 "8c1e8811201d1e9cc806b74393db16e89a119f412e16bb5f6181d54cd102eb4f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6925866747f2c9c75543302ea5bd7072ae4bf9f3207c19653a98a0671afd2b78"
    sha256 cellar: :any,                 arm64_monterey: "a4119f3582c18811980667b64acee794c5f495073d5363bb441586a9d6db7e76"
    sha256 cellar: :any,                 arm64_big_sur:  "dc3ca964e236c1e1adf9e723734092dbf33d450f110765e166a2ff3d8e9aa1a6"
    sha256 cellar: :any,                 ventura:        "a0ab210846a244b2e9ada89c523574f750dab7907b6ee9d6e1dc5a1cc6abe0e5"
    sha256 cellar: :any,                 monterey:       "09d227bba09e97a5a2ee34f1b4d713fb93075c2d48188d30d92815adf88f2cf5"
    sha256 cellar: :any,                 big_sur:        "f735ffb238d1a412cb0f44c8f3925475fc778ef28a42f3cc3d2ce1e0eb4e79e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dfb8f833cfebccd03267172f3f1fcb7f35cc103ecb30bfee464bdd8262deb57"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.3/otp_doc_html_25.3.2.3.tar.gz"
    sha256 "78c0c6c50431cbfeedcebbea49df24f430bc377639a580b093294680cb5e1a49"
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
