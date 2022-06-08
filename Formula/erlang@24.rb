class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.1/otp_src_24.3.4.1.tar.gz"
  sha256 "f5c502dfab713a83f73eabf79fb6d83ac85d53386a571f55c2297e165a8145de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0bfe42a56f8c20941068547b35d3631449b8df1edb5a334ef5f4d09ce529e5e7"
    sha256 cellar: :any,                 arm64_big_sur:  "2f833ded35fa4e2dd6de482a00ec4a9bcddd498cb468d233ee2173d50172b39f"
    sha256 cellar: :any,                 monterey:       "dd35aac6b8d4720da99e948a32a17d32f72a9aed4ea3f67a53de94da119bdb8a"
    sha256 cellar: :any,                 big_sur:        "6c938d1a9f93444d5790d43e9ea0529e16d5b3926920ef02731c7b73faec5471"
    sha256 cellar: :any,                 catalina:       "9ced7aeae75705541ab6992b65221c4a4b6670cb618cdc06c523b7edb60f0939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d283aae434807295e418df760dbb5fd59c507fa5bc88f393132c5ad778e715"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.1/otp_doc_html_24.3.4.1.tar.gz"
    sha256 "76f2c49e91d23fb012111298959b7a5655dc53fb3dba7ddbe27003112716aff3"
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
