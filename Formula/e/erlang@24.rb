class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.16/otp_src_24.3.4.16.tar.gz"
  sha256 "aad5d79ab7554b5827298024b722dbbf54bf01b9a5737e633e93e5953fadc4f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a4bf658939302bb5b6770d7a9db05ddb0f094e68e6e1ceb96424bbdfa8e6315"
    sha256 cellar: :any,                 arm64_ventura:  "1f35e2150fc5b6a6cd51de541b2e0d4bc9dedafbb1d755f5a7a8b43b988251a1"
    sha256 cellar: :any,                 arm64_monterey: "2e3c2e272e82607eb27f5097f61153332203d7a29d42a8a3fd4928dc5948bfb8"
    sha256 cellar: :any,                 sonoma:         "3d65ab59a1ddc652efdc70c52d55f44b0cf31e9506256ced19c43f38c6ad94c6"
    sha256 cellar: :any,                 ventura:        "71ddc4dd3e15d87e146198e5bb947becd43d2160848a214ec25292b8b66272ef"
    sha256 cellar: :any,                 monterey:       "6148169dd11a401fd5355af293de744b6c70df0780466962321da16c5ae2e2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ec01b7ba7941565663ceadbd1fb3fe30e0543c439fbaade64549c684396dd5f"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.16/otp_doc_html_24.3.4.16.tar.gz"
    sha256 "42f33957f4bc3fd46ece5a7dd4038158c9dcb59e0922d52dc433a5a0f3a5b3f8"
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
