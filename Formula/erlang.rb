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
    sha256 cellar: :any,                 arm64_ventura:  "ba18898b9c24853c2347ddedb22308b568f181ba2ab945f11822c7b5cb25a680"
    sha256 cellar: :any,                 arm64_monterey: "d67264dfb9610a66fe16dc376f46c5fc35eea86a96f17f3c9f35495513ab1b38"
    sha256 cellar: :any,                 arm64_big_sur:  "999e22efcaa3b39505ed48d55a4c30f0594153a48128e863607a0c4ce7583347"
    sha256 cellar: :any,                 ventura:        "7b20e30e9077bd14a31b323efe4e9f83272b6eeb37ca723e5ee5c4696dc27f0f"
    sha256 cellar: :any,                 monterey:       "9ced30f79622b6419f995218ea92766f87beaf1bf8fd6fbafdb64ff06f84aea9"
    sha256 cellar: :any,                 big_sur:        "b9423756d742d5bbc59622676e980eb53698c13a2e478b4f3f2a46dd9a2da956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b2c8531b5743c36eeec156e07c0ea967e89eeb4a1f97ef0f8b78260898e1e6"
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
