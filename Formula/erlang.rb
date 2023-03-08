class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-25.3/otp_src_25.3.tar.gz"
  sha256 "85c447efc1746740df4089d75bc0e47b88d5161d7c44e9fc4c20fa33ea5d19d7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98e31d111810b58de86f96c8194592175f92e915a6311eeeac9ed671c1a36366"
    sha256 cellar: :any,                 arm64_monterey: "23b6a05dc3e762d4c39d8132a76405d0bb881574764fee5a0cc94ff3b6e2fd9f"
    sha256 cellar: :any,                 arm64_big_sur:  "a334df16f91f6d286fe3891080abb5d6d4cf937f4128b743340fef767dd1db94"
    sha256 cellar: :any,                 ventura:        "ae3802e9749495f8de068ca9a1ef4b4245c4ef2d0d5a12861baf70d7a501281a"
    sha256 cellar: :any,                 monterey:       "cabe15f8d035a357ac46787038acbe21333cccd83f04fe0df443b111b4de8b40"
    sha256 cellar: :any,                 big_sur:        "c1b7aae50045546f05f9110b1806df57ecdffa7e9f97fdd02e40cb7b78bcb638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80b2a3f9f24153c89bed8dab23df11052ab66ff9611c53962f2f87ffe24984a9"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3/otp_doc_html_25.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.3.tar.gz"
    sha256 "bc5f24a115e436dd73e617c7cc90d6e7d6e20fd43c0bae3f929333887d96317b"
  end

  def install
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
