class ErlangAT23 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.14/otp_src_23.3.4.14.tar.gz"
  sha256 "35123f366ded534775a05db8ad6c06c20519ae228af1b5952132b10845621f21"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(23(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a9a9a09efca63956862e4984e41aa07a3e2b686606ee6aca926f9c73c687d90"
    sha256 cellar: :any,                 arm64_big_sur:  "8f840ab6cfb238a26c9023b807fb6d6183f951179b671a4d81c7201715cfa5f7"
    sha256 cellar: :any,                 monterey:       "a6c9b59bfbf39bd19e33c42170a2fe87f003a53c019c72455859ea761ddf1a0d"
    sha256 cellar: :any,                 big_sur:        "060bbd8cb7f80c37592101f6e80836a168d1ce91bc988fa2af7e05f56323eeb2"
    sha256 cellar: :any,                 catalina:       "32d06cea0dfa89e440a2b5068f9691c3ec23f9340cf40f10745b14c4dcb52136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4035752ccf49b2a63781a1ac06841421f52dcc1ff9dbd9374450fb8b082723d"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-23.3.4.13/otp_doc_html_23.3.4.13.tar.gz"
    sha256 "37e2aeee06def0921aa35f4b306a42984328928caaf881171e076e95b6c8a57c"
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

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

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
