class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.11/otp_src_26.2.5.11.tar.gz"
  sha256 "69cf6c2cc4e54e8d0bab8f9893f0b61dee10bff575c3535d47b6057a468751b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5be22f8fb7e8cd8f18bfbb9cefdc9e3cc97b6aa85ff3e315adcab8ce1fb893d"
    sha256 cellar: :any,                 arm64_sonoma:  "63618142e88afeb2a61cc64494ebcaa6f3f6b3a0508630ec62f906800d1709e2"
    sha256 cellar: :any,                 arm64_ventura: "2535535a0539653b621c507f1c218c5fa910ae27514e296b006625a8a93e0c0d"
    sha256 cellar: :any,                 sonoma:        "0fdacc0bda3c1aac318ccb8081291c08524c06d250e5594e187ac7e9b8d0a5d2"
    sha256 cellar: :any,                 ventura:       "1ff45071d476e1324a1c0a9c09c773f4e590297dbb33e5c26d2c44c204db7ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a91ad704a5fcacde934ca12015a7010d56f86b05bcde71572b858b5d507f09f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f224047bd25bc8e4b4e61901d83b58fa739b83e7579de04e958fb821e708eb2d"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.11/otp_doc_html_26.2.5.11.tar.gz"
    sha256 "b84425b7ad8e33a99f17d17a123eefd34b2407bd024f5600c1c7da0bbb7223d9"

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

    system "./configure", *std_configure_args, *args
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
