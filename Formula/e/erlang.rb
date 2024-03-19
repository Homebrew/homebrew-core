class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.2/otp_src_26.2.2.tar.gz"
  sha256 "d537ff4ac5d8c1cb507aedaf7198fc1f155ea8aa65a8d83edb35c2802763cc28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "91596c2dda7291005c6b07c52f3df2d94371cbce4c3a86357813ecb21c93de97"
    sha256 cellar: :any,                 arm64_ventura:  "3e35b0b9597f449a97adacecb6f9a7ad1c4c6cf48a7cf7be02def96a8da5192d"
    sha256 cellar: :any,                 arm64_monterey: "3b83754e1a23deb4ac368ec6f4a73b4721651c968ef3c599fc6f6786fa177a68"
    sha256 cellar: :any,                 sonoma:         "d04c8c55d1c8571fd777b7c144577a7fba1b98c823e7ade9f94b1dd264e71df1"
    sha256 cellar: :any,                 ventura:        "3100f41005003e97694c39048b5c2422f01acaec081c3f528982cd6914466cc2"
    sha256 cellar: :any,                 monterey:       "5aab61973b32d6500aa1a6177a2a2c39c3f857de054aba56d2f52d75c5a43119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ce780826fa9343b7408b46ae2c1e16e032f9dbd4215c401e94f77c7bdb3f92"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.2/otp_doc_html_26.2.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_26.2.2.tar.gz"
    sha256 "d80a6aac6c7357ee9e0ef7996b236f6e4e89185d6a3d7ca7f0d5bc57a3f006d9"
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
