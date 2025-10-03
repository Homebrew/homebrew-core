class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.17/otp_src_24.3.4.17.tar.gz"
  sha256 "0bf449184ef4ca71f9af79fc086d941f4532922e01957e84a4fec192c2db5c0c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dc7fb39df4822f6aedb31cdda284b8a1bdb8d23907d9c1f5391a5daaeb9cea0"
    sha256 cellar: :any,                 arm64_sonoma:  "c23064f7cb67c96c630da1a470b9181c9296bdb74e347f77adf63a8fe493e9e6"
    sha256 cellar: :any,                 arm64_ventura: "aff54c8543fb8471bfd80e565a9abea7a212835dd59802291035a108007396a9"
    sha256 cellar: :any,                 sonoma:        "429e934b2cc7246538235f09c3f999cac23d58e41e4350ef94a88c4c88c41cd1"
    sha256 cellar: :any,                 ventura:       "7ad814904a5b00ae3b698f37ed52bc16ec1bf4526e39c4171ee2d694a3aa7d4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e94076e1922d3a01253a031443cdfd5efebfe18cac0f6cfca22f0fd940307fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3d53a2ec45d9831e696febdaa39d29febaa56f23ce2e2f1454de2fef5bb4fc2"
  end

  keg_only :versioned_formula

  # EOL with OTP-27 release (2024-05-20)
  deprecate! date: "2024-07-24", because: :unsupported
  disable! date: "2025-07-24", because: :unsupported

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

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

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
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
      --with-wx-config=#{wx_config}
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll"
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    # The definition of `WX_CC` does not use our configuration of `--with-wx-config`, unfortunately.
    inreplace "lib/wx/configure", "WX_CC=`wx-config --cc`", "WX_CC=`#{wx_config} --cc`"

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
