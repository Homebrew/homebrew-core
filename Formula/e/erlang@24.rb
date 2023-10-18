class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.14/otp_src_24.3.4.14.tar.gz"
  sha256 "137acf8c11edb567aa91a19fe3a00b61918fe8b41a89236277bef97a83e5b009"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1128556fd507db07330238f17e8f728a6ea447a0b8887d4ab01e5949f5db1b02"
    sha256 cellar: :any,                 arm64_ventura:  "ae91d8cf7c5aaa8ef9d877ace2a94fff03e741b7f9370c50137a2ff23e683eee"
    sha256 cellar: :any,                 arm64_monterey: "9aa3efa0e450be6f58998852af5bd3489f27f6d126168e8fe8fd7628b962b9f4"
    sha256 cellar: :any,                 sonoma:         "8e2c1efa0a64e32c7403296452989665e8efe3daf3248bde97f56c60b99fc935"
    sha256 cellar: :any,                 ventura:        "6ebe5324c1966cb1931d6cbc301caa3dfeb889dd2f7356e5eedefe24f888c457"
    sha256 cellar: :any,                 monterey:       "c774d3e85d2493d29495ac8cfba0083af3924ef8ba60b8447d6cb96fbc2d47a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10dc10d20e925ad095149018f31f13a5a26f635f709793075c9b80e3e478f316"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.14/otp_doc_html_24.3.4.14.tar.gz"
    sha256 "0182fd64ae7a7f3df7abaa7cfc95ec54d1259be7b2bc541facec4c2c595cf254"
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
