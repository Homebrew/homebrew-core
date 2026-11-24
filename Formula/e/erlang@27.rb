class ErlangAT27 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.20/otp_src_27.3.4.20.tar.gz"
  sha256 "9717de6c0b7ca569770e09c70aa3d36b88a53d509bacfa8688927fbfd119e7ff"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(27(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "584eceb63d72e0f6ec4328356975df88450dba93e4e6440ccc5205f20a8e9873"
    sha256 cellar: :any, arm64_golden_gate: "2415df81f5de8b6dbb995f9f70b63c8d4972ac49507daf689e585901fbd01052"
    sha256 cellar: :any, arm64_tahoe:       "c31de9fd05b04d412fdbd6da7bb994dca6bffa6abf4c5bfa6a1fef527322485f"
    sha256 cellar: :any, arm64_sequoia:     "82b1c079f0cacc482ef4462df37827ded88a8054173c5f18ac9a2b404e3fa465"
    sha256 cellar: :any, arm64_linux:       "446cc2fd7f95c5c2268370e559deb4aedb290b82f24e3d0fe396ebbfc9b79c48"
    sha256 cellar: :any, x86_64_linux:      "3ee2b7ac168038f4a49508518d11cc342ffcacaad3ef8c6c7d0f179a4105556d"
  end

  keg_only :versioned_formula

  depends_on "openssl@4"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.20/otp_doc_html_27.3.4.20.tar.gz"
    sha256 "6f83185e139cb39e29c891ce14642d68e94982130cb76548ddcb97e6f172d1ee"

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

  allow_network_access! :test

  def install
    ex_doc_url = (buildpath/"make/ex_doc_link").read.strip
    odie "`ex_doc` resource needs updating!" if ex_doc_url != resource("ex_doc").url
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    wxwidgets = dep("wxwidgets").to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"

    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{formula_opt_prefix("unixodbc")}
      --with-ssl=#{openssl_prefix}
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
