class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-29.1.3/otp_src_29.1.3.tar.gz"
  sha256 "44d8ee7f0964537ddb328fe2f6307d3338c3fdd1b2826938d490907771ba70d2"
  license "Apache-2.0"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "0b77e5dd692e1ddeb6138ce3bb2093af97eabd20fae97dcd87a006d253789ffd"
    sha256 cellar: :any, arm64_golden_gate: "0a25aeffdf3720a0163ab866052395244567c9cd04730c381d672fd9746662a8"
    sha256 cellar: :any, arm64_tahoe:       "cbc8a5a3edaf966aac8ac604377e42e8a2a28e463496fdb2dbef65a5a669b1e5"
    sha256 cellar: :any, arm64_sequoia:     "4af8bb0d1520631aa9e67eb1fd6475d95bb3432e934a8bbc3363f4f7a01a014f"
    sha256 cellar: :any, arm64_linux:       "684eed6eb98bf4a0c20405d653fc4ea405058499238541dcbc4955432f83f272"
    sha256 cellar: :any, x86_64_linux:      "4aa459f32ee02dc23f07572db673651aa8b8b62aa023ad1ec2eeb11ed631463d"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

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
    url "https://github.com/erlang/otp/releases/download/OTP-29.1.3/otp_doc_html_29.1.3.tar.gz"
    sha256 "b83e6b0542a7e1308b9fdbf959c591849be37d395c15d9a778ee101ba5046006"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.40.4/ex_doc_otp_28"
    version "0.40.4/ex_doc_otp_28"
    sha256 "118ba88f04a1bedf665d34f3c1f6312c6d28fcbea34bb1166c74c54339e02b69"

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
    # OTP 29 removed `--with-wx-config`; configure now reads WX_CONFIG_NAME.
    ENV["WX_CONFIG_NAME"] = wx_config
    openssl_prefix = dep("openssl").opt_prefix
    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{formula_opt_prefix("unixodbc")}
      --with-ssl=#{openssl_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll"
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    # The definition of `WX_CC` does not use WX_CONFIG_NAME, unfortunately.
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
    system bin/"erl", "-noshell", "-eval",
           'true = filelib:is_file(filename:join(code:priv_dir(wx), "wxe_driver.so")), halt().'

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
