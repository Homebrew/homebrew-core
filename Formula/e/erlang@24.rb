class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.17/otp_src_24.3.4.17.tar.gz"
  sha256 "0bf449184ef4ca71f9af79fc086d941f4532922e01957e84a4fec192c2db5c0c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4b033ab7693bc346cfcdc745afe84cabb0a67326ec1651cd2294e6f0bb84eb24"
    sha256 cellar: :any,                 arm64_sonoma:  "034839e7b3d701ed14dfb55a2e025bacc979106e12907a94f65a367bb71c13de"
    sha256 cellar: :any,                 arm64_ventura: "57b237d5803642973cb653d25c8934a34edbf72ee1b1624ae328d6928ba3144e"
    sha256 cellar: :any,                 sonoma:        "e3a714e6cb9575535d9f42a82e21757285a1cfd9141055f4924392768bdde52f"
    sha256 cellar: :any,                 ventura:       "bd2eb3ff1de20d55737b6de2d6fe806f557ed3e1c25ac1c9aa875e50396db8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35c345a8de635902b798111366a269f48cbe5940eb4c12934f857327ec448c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d7b48ce5b43fe07e78116d0c40ead3da8c54876a94aba05f7e4f893954e76a0"
  end

  keg_only :versioned_formula

  # EOL with OTP-27 release (2024-05-20)
  deprecate! date: "2024-07-24", because: :unsupported

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.17/otp_doc_html_24.3.4.17.tar.gz"
    sha256 "f9aec1b812dfdbf2dc259f9e93c037f346259b7baf391705b6c1c4e29a4eaac8"

    livecheck do
      formula :parent
    end
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
