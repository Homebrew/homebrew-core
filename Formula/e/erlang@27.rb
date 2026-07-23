class ErlangAT27 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.14/otp_src_27.3.4.14.tar.gz"
  sha256 "cda7508a1aef446824f5fff4d64f1b1ad6365e7ad9a5f9d7300f6b6b3aef7015"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(27(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc0c09dca184d74b1ff38dc3ac71d8274407d47a815f5d24096a693a27b43a20"
    sha256 cellar: :any, arm64_sequoia: "e56f99a7de0f1a38b0f09017d8ad3f513cb999fdd6acea4c21b9ccaa8ea278a6"
    sha256 cellar: :any, arm64_sonoma:  "1c9955f66da4c96ee7aef4af320cea60724b830b214fd33f9088baba988730fe"
    sha256 cellar: :any, sonoma:        "9c7a901d9c349ef322c77951a1dc7b8e8ec0e6f93d3fb5b887c2851d05111d95"
    sha256 cellar: :any, arm64_linux:   "c4739b92564ea12d69985f73f60ce49436fc3411b67983074de8cedb5c5faed1"
    sha256 cellar: :any, x86_64_linux:  "bcda97f01b2e7351a76657e1b0ebba7749a3e14cf703c0322f8adf248405bd2f"
  end

  keg_only :versioned_formula

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
    url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.14/otp_doc_html_27.3.4.14.tar.gz"
    sha256 "476066cd84139a7ca731d898f9802f6640dd1e1502952542a629062b8b5ce12d"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.37.3/ex_doc_otp_26"
    version "0.37.3/ex_doc_otp_26"
    sha256 "b127190c72fe456ee4c291d4ca94eb955d0b3c0ca2d061481f65cbf0975e13dc"

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
