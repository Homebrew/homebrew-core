class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.21/otp_src_26.2.5.21.tar.gz"
  sha256 "e1fde86f4e2874d4c136221a34753b5b785d762b910fb3fb35a23a6a7faf0a64"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b1dbfa63890bb11e0beb4f69d4e43b3b0dbb16167d8b5c1bdd431276ce05236"
    sha256 cellar: :any,                 arm64_sequoia: "562520d8643c16d939f5279746ce653492df1f0685496d7ea1541c12e0ceceff"
    sha256 cellar: :any,                 arm64_sonoma:  "6d00dd641199b90b37181be23b2c58915a56594ab54f6408225c554ab27f80ab"
    sha256 cellar: :any,                 sonoma:        "4746bdba1010c2fd05a1b0a484548a1d4d8fccbc88a41b0f7f0d5232c29ce40b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4e88e06263348f4944c44079f46110348fc95d901ac6e80f51c75c7a5b8205d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442f37c41256f6fdab998ff494092057243887bc2495102c4177e473d2447cd1"
  end

  keg_only :versioned_formula

  # EOL with OTP-29 release
  deprecate! date: "2026-05-27", because: :unsupported
  disable! date: "2027-05-27", because: :unsupported

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
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5.21/otp_doc_html_26.2.5.21.tar.gz"
    sha256 "f403cb0218bbcbc479878fc75c7c61e914c0c867b6eec41cfb46f2178b9e43b1"

    livecheck do
      formula :parent
    end
  end

  def install
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
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
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
