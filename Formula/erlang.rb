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
    sha256 cellar: :any,                 arm64_monterey: "6d1d1872e0ffd23aaf68c94a115077e268e401743695601bacada90a2e5cd5e4"
    sha256 cellar: :any,                 arm64_big_sur:  "9e5ec86007d18cc94ab5ccf4eb49b09e701bc0d381e1e0c89f4bbcaab7e03100"
    sha256 cellar: :any,                 monterey:       "93e8902c4912b349792a1547d04d00fc2f46f67830a037fea55e324b38b1b123"
    sha256 cellar: :any,                 big_sur:        "fa0a7ba6f10e637c83f905256fa4ee410250f0f97f748e39c885e09485290a9f"
    sha256 cellar: :any,                 catalina:       "f3347ac517482695e097abd972d38cfbe97c52964f5e208e0f329e381ad0888e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c1927e4e7b7fb165dff0f891ce10690091ed14c1ad27a657319494e93416b79"
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
