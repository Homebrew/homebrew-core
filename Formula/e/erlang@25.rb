class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.13/otp_src_25.3.2.13.tar.gz"
  sha256 "00c2619648e05a25b39035ea51b65fc79c998e55f178cccc6c1b920f3f10dfba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8b929704f50d5d559b02c640959e0b696c7727ca73cd3ee2d52e481d8c296e2"
    sha256 cellar: :any,                 arm64_ventura:  "59b9a57244dfa716fb1e0ea46d0fb82ebeb1671057b5f8b41e81865f7f2d57e2"
    sha256 cellar: :any,                 arm64_monterey: "d8cc1a1c72e446ea7f037d6f73d99101a6aa7e067042df8b2b636460a968210d"
    sha256 cellar: :any,                 sonoma:         "0828738897d74cc1287611d98f2be881fa858f2c33f45728d41bb70ad2eb8baf"
    sha256 cellar: :any,                 ventura:        "31cf2560931de9523f1b36a05a2a085bc7bd26d85a7a027a3fd9feaa9e541b98"
    sha256 cellar: :any,                 monterey:       "cc48c4f1ab3f8c1280fbe29b54546ea890f6a564ca6f02065646c41e18f12782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e75ab95ad14f6eb3aa8ee859bf172c46393ee8774cb714d794f07b09965562"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.13/otp_doc_html_25.3.2.13.tar.gz"
    sha256 "d57d0b5426a120531b3109c91d604765f386fc5c4420c861fcf259430cfb3671"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

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
    system bin/"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

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
