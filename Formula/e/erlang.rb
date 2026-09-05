class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-29.0.6/otp_src_29.0.6.tar.gz"
  sha256 "36c89ffdac9d7531c19be0cee34355b167ea95188625d32bee61ebf49ac82afa"
  license "Apache-2.0"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "60e6425e089726bcae182f1856b01aa88de2782b94dedf71559e8efbc5eea0f3"
    sha256 cellar: :any, arm64_sequoia: "87f5c6684693032fc94427a7c0e3909d9025360da1ebc95dfee3ae45ff8561e0"
    sha256 cellar: :any, arm64_sonoma:  "448b6099a69b17cd2b3d3d0450f84cad7287055f104e1611efa6b76fab57a48a"
    sha256 cellar: :any, arm64_linux:   "83f8843d0e2a8358aa6980c4b9b2738fb97b9fae106d6518d3e52516381d63da"
    sha256 cellar: :any, x86_64_linux:  "0d213d68797f0cdf6100556e5a6ae779b6b68e20511ba149498a080057d4bd96"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-29.0.6/otp_doc_html_29.0.6.tar.gz"
    sha256 "13ed0cd1abae1b53ddce62ba2ce8faf6af4b472cb5618ad6285dafec50dccc6c"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.40.3/ex_doc_otp_28"
    version "0.40.3/ex_doc_otp_28"
    sha256 "b7428a78cd57ac68ecadd6f2b1ae18c0ecaec4b51b8f04bfb114967c034c7596"

    livecheck do
      url "https://raw.githubusercontent.com/erlang/otp/refs/tags/OTP-#{LATEST_VERSION}/make/ex_doc_link"
      regex(%r{/v?(\d+(?:\.\d+)+/ex_doc_otp_\d+)$}i)
    end
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

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{formula_opt_prefix("unixodbc")}
      --with-ssl=#{formula_opt_prefix("openssl@3")}
      --without-javac
      --with-wx-config=#{wx_config}
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll"
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    # The definition of `WX_CC` does not use our configuration of `--with-wx-config`, unfortunately.
    inreplace "lib/wx/configure", "WX_CC=`wx-config --cc`", "WX_CC=`#{wx_config} --cc`"

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

    (testpath/"factorial").write <<~ERLANG
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
    ERLANG

    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
