class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2/otp_src_25.3.2.tar.gz"
  sha256 "aed4e4726cdc587ab820c8379d63e511e46a1b1cc0c59d6a720b51ae625b2510"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c1378c5715e283aeb8f73cc52a57ba55977719775409f1470be3ce7dd74c0fe5"
    sha256 cellar: :any,                 arm64_monterey: "2a57e84479319d0ec8bb511baef9e4e89203953325f5ce52ae42b9ed617d895b"
    sha256 cellar: :any,                 arm64_big_sur:  "a2e541828a356ecd41bca87dd0b9d81134a609e857c75b82c160603ce28b5386"
    sha256 cellar: :any,                 ventura:        "f123764e275e2a5562e1f30cee2e0ca36b5bc13b6b0426c83eadebddc0891dd7"
    sha256 cellar: :any,                 monterey:       "39db52a93b3d4a7b749b0d75ec9df8c78a89485cb52ed77bab4773cf1b354cb9"
    sha256 cellar: :any,                 big_sur:        "87187a376ff4f022f96da5e54ffc3c7ddcfe08cf7b4c2fbbff4b6bed5f74da4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07402178aed73d7d383a02ee92c398d21f9cea3adb674d324aff6516c98ef6fb"
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
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2/otp_doc_html_25.3.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.3.2.tar.gz"
    sha256 "44e88d7b839f2cb3ea7ae60bd3a2122ed002e05d8a47da65bc3a1210b1d0aaa8"
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
