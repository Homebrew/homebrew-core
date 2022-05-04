class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_src_24.3.4.tar.gz"
  sha256 "76fcca5ba6f11eb9caac32bf053badc46b5d66f867150eef077f4f0d7944ecd7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da6a86780f1c592fdbe8e23f368462eef47206e40be070c5575438d8be3581bb"
    sha256 cellar: :any,                 arm64_big_sur:  "2c888285a6e4b06ca4d5c80b6cdd522be82305ce675fb5c648b6f225d16a343e"
    sha256 cellar: :any,                 monterey:       "25313fa975dcc8a76c4deea7c3ee6be662090d8a7c41958e1182ef8550d0dfa7"
    sha256 cellar: :any,                 big_sur:        "d5ee4e7aeae2157f070425afc1f65fcc151f7c4a14fc3ccaa89ced8057401a4d"
    sha256 cellar: :any,                 catalina:       "b339ea800c50d039df5595d10d9435e68e53b4b3aee497b3062ad7671aaa83d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21523f8ae99476f319309ca6c730eb5099eba43304c727fbdb034f51bf64edfa"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4/otp_doc_html_24.3.4.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.3.4.tar.gz"
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
