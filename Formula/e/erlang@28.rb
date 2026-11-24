class ErlangAT28 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-28.5.0.9/otp_src_28.5.0.9.tar.gz"
  sha256 "3ecc6abcaed81fa45f17aabe7677136aaf53247d533727fe51a778c369d2142c"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(28(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "256beb9f020da28b1d2424ace553bf71e7f3f8fc6a5693f0c5a08e10e8b3ebf6"
    sha256 cellar: :any, arm64_golden_gate: "7d878b52acb7522b482eb47fe0a63339a983f42f0a26b7d1d256fdab12ee10b1"
    sha256 cellar: :any, arm64_tahoe:       "e6b8638bf47b5e81c0e97d669a359201c6219a5c13152c8f66c39ddfd72d7c44"
    sha256 cellar: :any, arm64_sequoia:     "0f50137b62b0c3ad65cb1b6541fdc0d3c0229b311bd5490cdc963e28b66ea84b"
    sha256 cellar: :any, arm64_linux:       "75379d645339f9c8e6a6290f8bf4679f19a97772eb4cc3ae7a1f74d4563300b8"
    sha256 cellar: :any, x86_64_linux:      "3b068adb15a118eac1a5d2f5e41b2b8aefdd419a4f53bdeee7707750d4ac7a5d"
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
    url "https://github.com/erlang/otp/releases/download/OTP-28.5.0.9/otp_doc_html_28.5.0.9.tar.gz"
    sha256 "6a1af24b36e9ba4b58f7d5090f3cb0518603a3c6a89c79b3e2cb7842c54d7ad3"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.40.1/ex_doc_otp_27"
    version "0.40.1/ex_doc_otp_27"
    sha256 "1addd95c8b3679580ec9f368c973955e6cf7b4456a30f2ec0f68e51982913495"

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
