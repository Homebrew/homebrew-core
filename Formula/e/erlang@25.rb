class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.21/otp_src_25.3.2.21.tar.gz"
  sha256 "99296fcd97a2053c5fcde7dc0ded2ba261a3baf1491c745fca71bd9804d51443"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33f70df37d2196f26aeac6cfbb090d8d9aee8007ab809e72aad4d41755ce5474"
    sha256 cellar: :any,                 arm64_sonoma:  "586d85e4927c178beecf49b78dcd9f27ab1624a0d7220195df1c0eaba6ca84ee"
    sha256 cellar: :any,                 arm64_ventura: "f96554ee4d044b5ed8e24de4b842013884e6c0ecc6f6989b83318d1780eb9578"
    sha256 cellar: :any,                 sonoma:        "3dc4acb51bb1c44d77972dcf7d6fb6d06e780e897da2f01f33b60450818af277"
    sha256 cellar: :any,                 ventura:       "5497f5c8323560b7102c5f07e1e2dd197d9aeca4c3897e5d9a373ed09d523025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32b3de963e79192d67a7b20cde3f9293b235e4e53755263fb48bbf65cef7ed1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45e3365abc498935ba904303f9a1e81e4354e251d04080984250e8d814835bf2"
  end

  keg_only :versioned_formula

  # EOL with OTP-28 release (2025-05-17)
  deprecate! date: "2025-05-26", because: :unsupported
  disable! date: "2025-08-26", because: :unsupported

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.21/otp_doc_html_25.3.2.21.tar.gz"
    sha256 "686fde552fec0cac7a4a100320a1dc82b15e57c663c3c726b3f292f2abfd7e18"

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
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
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

    system "./configure", *args
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
