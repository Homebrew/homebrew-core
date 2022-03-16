class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.2/otp_src_24.3.2.tar.gz"
  sha256 "fb39eecf5a5710200871c85c11251e27afce7c2a11f569bd6394c6d48240ec8d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a3de3234490352760415276bfae5d904645ff768e7f3b33e5a4862aeeeb49aa"
    sha256 cellar: :any,                 arm64_big_sur:  "5119e0e5d071cf9bb96994d297a7874b612669e2080d0d4849d4c9b6415bc4cc"
    sha256 cellar: :any,                 monterey:       "7fb531bdbfa832121c6ff414edc90e8cbb222edcc9bdecf3ae6d090bf6d8c2b7"
    sha256 cellar: :any,                 big_sur:        "a29dc0a129cb65670931eaba7f40a31d193b28a775572ac0f8d4a3d2b4fd4bc7"
    sha256 cellar: :any,                 catalina:       "38ea0954ec2d37a558bfdebe2522a3dc04bcd277d98f4f492853958a9b7bfd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232ec691729ef52d68f3119ea7f04c932b595856678910c59209b2c4226f5784"
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
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.2/otp_doc_html_24.3.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_24.3.2.tar.gz"
    sha256 "abd04f30e4a5d252281156433fabb34419eceda153518033e972cd3d11ea8cf8"
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
