class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.2.1/otp_src_27.2.1.tar.gz"
  sha256 "07982134e10637dde57cf9cdc6dda6f65425810229986136d184766d4db9eda3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "096ab1dc5f4e95ec9e70659cd26890bd60f00d88647f235cee11f80b0d2a5be0"
    sha256 cellar: :any,                 arm64_sonoma:  "498508c63b3d2c774ac6d4bee145684a5cd32099d904df0df0a7e7cd5db2f220"
    sha256 cellar: :any,                 arm64_ventura: "92b20a46624140e126202ca509bb292a525d62324b4aafeaf01ba65816df3ad9"
    sha256 cellar: :any,                 sonoma:        "28f9542944c5833721152cfabc04d1d1e13f06edd2dab6b5a92b437a0a52b994"
    sha256 cellar: :any,                 ventura:       "494b774322fb0b625140ec8c7af9ca4121ed4733d10e26ce7686eaaebd9496e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4ff800cfc566207f69386cf4de5e9474974cc710ecb14995b663796421a8fe"
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
    url "https://github.com/erlang/otp/releases/download/OTP-27.2.1/otp_doc_html_27.2.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_27.2.1.tar.gz"
    sha256 "d0e1edf2018d31955d21ac6396cfa38543e6f7f77dcf0f439a2a3be94ba032e5"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.34.1/ex_doc_otp_26"
    sha256 "d1e09ef6772132f36903fbb1c13d6972418b74ff2da71ab8e60fa3770fc56ec7"
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
