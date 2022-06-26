class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.0.2/otp_src_25.0.2.tar.gz"
  sha256 "6a5cbc8d0f18e7a7fd2fb3d1567e2b70737ee4124cb22980ad4ed663c61e010e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "25b9d82aae30c8857014db379293ed452010a73c29e305c2d875abb7da023c59"
    sha256 cellar: :any,                 arm64_big_sur:  "c162cd5e611d53e2e24ff34530a8bc33ee8f8c03d7953b3cdfca674bf76e818a"
    sha256 cellar: :any,                 monterey:       "af35916b60df2e96607e37d3a766c3e5a43ca987f4565b7e428dcdd8f4f3e7de"
    sha256 cellar: :any,                 big_sur:        "319830a0e2d61164b0e616ff1d6a8c8bf7b1f483b3025148a3bb48a98f4a0059"
    sha256 cellar: :any,                 catalina:       "6b141c0cc7da012cfd69bb506929c14378adfb751d8a58be0e6c2c69bd113b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "355bbce3c83cf30f8c055ef7ea9555a48ad1645134d1d579cbd1b5f6c2c2a31c"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.0.2/otp_doc_html_25.0.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.0.2.tar.gz"
    sha256 "1927c0536df13c03ecf30c223f56ae1f594f369ec5f8b88f6baa2c047bed151a"
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
    system "make", "docs", "DOC_TARGETS=chunks"
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
