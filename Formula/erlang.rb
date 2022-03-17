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
    sha256 cellar: :any,                 arm64_monterey: "9ce7e1221f0f3657940ccd454fbde6d53169c2c29adbb4d5414977795e1c65de"
    sha256 cellar: :any,                 arm64_big_sur:  "0d49f50ed91f86af5804ccc4a32e0d317b23b7dfd5611516e17e8a1217930bf0"
    sha256 cellar: :any,                 monterey:       "707268ac960aec8ba81a9c2c6162c2bcddfbde03af837ea203f6f8496fb81a21"
    sha256 cellar: :any,                 big_sur:        "2ba88446e14cebc5161d33b5967252367678fd3b43cdae97b230e52c168007b9"
    sha256 cellar: :any,                 catalina:       "40084f850de4ca3109153c9a6e2fd522eb730a123602f717ccfa6b80874f33d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4660c4d15faed4e78ca8ab0e467c0514c4b56fa00ddec4dbe576527ec47d2970"
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
