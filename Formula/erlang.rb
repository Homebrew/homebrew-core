class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.2/otp_src_25.2.tar.gz"
  sha256 "aee1ef294ee048c976d6a126a430367076354f484f557eacaf08bf086cb1314d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5db6d91e3ad84b5900cd457fc1b13b10ab851b1d5b8336c7c0aa06f68cbbaad2"
    sha256 cellar: :any,                 arm64_monterey: "8a620117e75d3d805005a08ce1fcf97bc754987a86d9745a3389f4fdf28a0a32"
    sha256 cellar: :any,                 arm64_big_sur:  "2ffc2d7fbdc9c90c9933373bee8626fde0050754a3315f5aacb10c0a3999d5c9"
    sha256 cellar: :any,                 ventura:        "920094404c98ac7075dedc5958e435486361028edee5d980a4968575c4e2a3c0"
    sha256 cellar: :any,                 monterey:       "cd88c2822737ce33e434fb2eedef375483a11102bc9b514a37b97e9de8b10bb5"
    sha256 cellar: :any,                 big_sur:        "b8226076b481dbbe9364a73fa83f561a4d7ba89bd55695fee31383abc1d9047d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f44eacc80d1248cc31c4da2a565e795b9c393621645aab96ce933753580c9219"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.2/otp_doc_html_25.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.2.tar.gz"
    sha256 "b08e933e4d8753039dfa03c47daec30f7a9194e5e41b8c3c318c6c95d861b252"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
