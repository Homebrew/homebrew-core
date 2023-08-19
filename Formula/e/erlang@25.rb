class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.5/otp_src_25.3.2.5.tar.gz"
  sha256 "1f899b4b1ef8569c08713b76bc54607a09503a1d188e6d61512036188cc356db"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "837bc50860adb8723e5539b164f90691b1ab3037d37264c63166844c4d1dbb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a349f46d54799b90317426abe4c9f59cc86026ccacf296ede29c698fccc4f999"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4336febcb80b2ffb0a72e6181a9c4d7e3acd6093139aa43ea9235096711bd1c9"
    sha256 cellar: :any_skip_relocation, ventura:        "c090769e9b39412ba85039d85b5b94976961ed7a2f60ed60b2efcfa2364eb952"
    sha256 cellar: :any_skip_relocation, monterey:       "8d92b667682e3558c810d396b2e6acecf335c6efc56ff277e088a6d32d896083"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd76a57df675a84cef6a06d7995f262d9e019176651487e8a2ff59c0863dcf7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ace061b82819ecdd073df17770a61478219d1fc668615aa4ee22062978e3a868"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.5/otp_doc_html_25.3.2.5.tar.gz"
    sha256 "9e9fcac4f545947bdbe9105ae3b5150b7390ffb4bef74ae8de4a3cad194adf4a"
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
