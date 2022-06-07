class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_src_24.3.4.tar.gz"
  sha256 "76fcca5ba6f11eb9caac32bf053badc46b5d66f867150eef077f4f0d7944ecd7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3beb40664607f93dfdc9b23f2e8fb3558e88f7a883f3db5129fb6a3641a2aab"
    sha256 cellar: :any,                 arm64_big_sur:  "1af8dbfe1699a929549a76d9281125743f8cfbb18723e4b5da363ee9b9cf7779"
    sha256 cellar: :any,                 monterey:       "668f8b892e1f29e5534dff29d68d73879e01a7bf4ac415b1bd0662bb41710036"
    sha256 cellar: :any,                 big_sur:        "fbab216734fc55f2016a06c05c681b212f7e3effcf3f154dc9edb0e5aaa366a5"
    sha256 cellar: :any,                 catalina:       "0aef3d9cf8cb67208db5f9af6eb915f112ff12a39e05b22a4fed629d69d96315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1bbb98e47ad07eee8b18863628ef108ed65dfc6f1acc40d6dd3d88c36b4e09"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_doc_html_24.3.4.tar.gz"
    sha256 "06ccc6e0eed46ea92557eb8fa8ad8edb7cc330a5fba0b520cce37c7275b95d84"
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
