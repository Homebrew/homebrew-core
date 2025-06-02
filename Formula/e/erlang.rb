class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-28.0/otp_src_28.0.tar.gz"
  sha256 "71b5bf16e5b7b5d9fae98576c87aceac447964aaa3b4b457a5f60906839af92c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6f34b91d8fd9ccb098e2a70566ea1a98a35694a583c3f2e6ab8730b3167e79d8"
    sha256 cellar: :any,                 arm64_sonoma:  "ec00303a27d53bb1cf29e58d78f67235f4e58652182c7962209f6b6de8f3c675"
    sha256 cellar: :any,                 arm64_ventura: "bfcaa62512a41f974b2187dec18bb0dbe9949af1bd96a4e0a7455a468e54a2ba"
    sha256 cellar: :any,                 sonoma:        "1f9058a4c7c459b942137a8e6b4dae2cec23de453c41481b2199bb21b4cefc7a"
    sha256 cellar: :any,                 ventura:       "9eb2fac132383f0b0c65e3a0cc163fa2e62d2516aa4ab3066e20fd1676242b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb0da9f8ed1232bfe0b7fb59de6500989209229aa205018812cd4dcd9adab869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d48e161828a1063028c3a2e55b94086a509e2bb3aa0fa6a1185a25ed0e199a12"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-28.0/otp_doc_html_28.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_28.0.tar.gz"
    sha256 "9eebbb8820f0a75d70d88758b32d3d9009828cf7d954f448a586639e74c5c65d"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.38.1/ex_doc_otp_27"
    sha256 "4aaafd13d056aeeca8b23a016b330114947c8d33ea657c22f637259e626e701e"
  end

  def install
    ex_doc_url = (buildpath/"make/ex_doc_link").read.strip
    odie "`ex_doc` resource needs updating!" if ex_doc_url != resource("ex_doc").url
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
    resource("ex_doc").stage do |r|
      (buildpath/"bin").install File.basename(r.url) => "ex_doc"
    end
    chmod "+x", "bin/ex_doc"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "install-docs", "DOC_TARGETS=chunks man" }

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
