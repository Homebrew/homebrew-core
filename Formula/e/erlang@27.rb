class ErlangAT27 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.3/otp_src_27.3.4.3.tar.gz"
  sha256 "597618c75890e8e606033bc8dbf6ec87fdf4e892c10b4912ae3c9a4f01384579"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(27(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91659ab8a6d90d19bc9a831d11c47f436235fee22d258dc1213bba77008ad999"
    sha256 cellar: :any,                 arm64_sequoia: "fd19f9892309e0e8e7cad7deab16b5eaaabbfa204b9edc8ef47e33785e031f80"
    sha256 cellar: :any,                 arm64_sonoma:  "35b65ae077084a775f5c6288659c83f9db924a439b52f67fa86963d460be1b55"
    sha256 cellar: :any,                 arm64_ventura: "013cf642f3bec376ecc8dfba262b6b08582146d1210f933e3d69ef32a965bef6"
    sha256 cellar: :any,                 sonoma:        "dc16762e77d1adc32e9d94372033dc0bcec9927068f27996cf94e4a674316c49"
    sha256 cellar: :any,                 ventura:       "c4cc115ca46eb02b5a6519d57a5ec92506a7caca95fc9e3e82a2cc0b8772744b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21676511973925db897314b3b9e94586648acee041acac5ddad44adf599f03c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ce23f056557ac911f1c740728b68af096e543c6eef68ffabf4a0c9a32d02a8"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-27.3.4.3/otp_doc_html_27.3.4.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_27.3.4.3.tar.gz"
    sha256 "c8b7c605593c74ed86e5d09d5835cb9c3b288f8ea9dec0166e0d58fad177b704"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://github.com/elixir-lang/ex_doc/releases/download/v0.37.3/ex_doc_otp_26"
    sha256 "b127190c72fe456ee4c291d4ca94eb955d0b3c0ca2d061481f65cbf0975e13dc"
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
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
