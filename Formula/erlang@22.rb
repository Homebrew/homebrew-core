class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.26/otp_src_22.3.4.26.tar.gz"
  sha256 "ee281e4638c8d671dd99459a11381345ee9d70f1f8338f5db31fc082349a370e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fe94c08097f877343680617d8cf297bb6bba5aa62785edf7b0c95f2c1191f576"
    sha256 cellar: :any,                 arm64_big_sur:  "7fefc63bf9aa8c76d34016da1f62d8914d504b3f898b256a4d6e268ad4f9921d"
    sha256 cellar: :any,                 monterey:       "5d7407b7351731b0282597ea32853813da2e52ea8ac283e0bfba0a8e8d0d889b"
    sha256 cellar: :any,                 big_sur:        "9f2cd9905eab2c0febb23740259b06d3c0c8197313525b1ddfec87a5e38da859"
    sha256 cellar: :any,                 catalina:       "639cdd72c78eb0148e2e7ab502bf7e6b53c5efbda0218bf59f173f9585129bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3896d1e7edbd1b5c23f3f0bd3d85a0b46076f0ef30b6de6ce1613caec693e7b7"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "man" do
    url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_man_22.3.4.25.tar.gz"
    sha256 "b715aada5a3abf0699d1c05ed55bd57f2110fb8fc58a9a67b6519d8ff8195fa8"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_html_22.3.4.25.tar.gz"
    sha256 "90bfd716b2189b858a62cf09503ab02eba211753e44025d39e800490642e0fa7"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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

    (lib/"erlang/man").install resource("man")
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
