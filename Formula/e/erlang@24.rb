class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.17/otp_src_24.3.4.17.tar.gz"
  sha256 "2f0661b1f98b01c26e2bde7234ef587f77e5ee0e384f3b1221496782bf9c8b28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "435837edaf050c74b206c802ddaca9acc8b4bc91a47dc6f7387940c87be60be5"
    sha256 cellar: :any,                 arm64_ventura:  "b2e6f1ff79876b37f0f87b83bea3cd59cf61a386752dd949320a3a6cc4067061"
    sha256 cellar: :any,                 arm64_monterey: "0dfc293d728a8a9788be2c0db87c331544178be32e28ad52e33c1a85af520d64"
    sha256 cellar: :any,                 sonoma:         "1323c8f08abc24b00c3283bf97758637b905633ca773ce9d32e1ac1d5ed20bc3"
    sha256 cellar: :any,                 ventura:        "62b408e9dbcc041e5dc6dde1854223e14229e72695461f6a38e2329486d3df7e"
    sha256 cellar: :any,                 monterey:       "f5f4b4e39497e0468a642ea5ae2b235d98f8c77d6f3c8680ee5536e1da5801f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc90832df7a0af8a752f84ee43d708d4c1da1889f399e32b826ce7a03784721"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.17/otp_doc_html_24.3.4.17.tar.gz"
    sha256 "cb76b9d11d7b6c023ae9ed869d716fc3528699c8a9d40477026a9a65720d8eda"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

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
