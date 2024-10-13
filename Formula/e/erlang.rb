class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.1.1/otp_src_27.1.1.tar.gz"
  sha256 "ff7319bbead79b8cde070ce9cdaeb8c18309c26868eb72051b02c77f58b9eb27"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae5c8b8c2b6e0f8988a822790c45a71e1ee5838ca04c16e594dfdf76ff61fe72"
    sha256 cellar: :any,                 arm64_sonoma:  "ebf68c68967fc6ecb0105a2c03159f7c68bf7799b62b09edc95019d6dc895cd1"
    sha256 cellar: :any,                 arm64_ventura: "2b6078f3779b016077e8d26965837abe64e1a4489cb88f2d6895a2189bba0e1a"
    sha256 cellar: :any,                 sonoma:        "fc3b5bb5ec8cd4be3303a23346be948bfafbe1569a2ea29dc5d56e1b3a79b7ad"
    sha256 cellar: :any,                 ventura:       "2340519a07fc86382c057552af340843e573cba202e482132d77dfd2adfc78ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a5592de961ae01573373b5ea5a50de2c26f8e75bef0055bee3293cea34d1bb"
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
    url "https://github.com/erlang/otp/releases/download/OTP-27.1.1/otp_doc_html_27.1.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_27.1.1.tar.gz"
    sha256 "f773296d1226052c245a41cee8492f264b95958ef4f4b153139b79337cc78d0e"
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
