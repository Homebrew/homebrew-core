class ErlangAT28 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-28.5.0.1/otp_src_28.5.0.1.tar.gz"
  sha256 "adcc18a958713356d251980004b552b66e9cd33493e7c60c325d2f523b33329a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(28(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba0634bd1920873475b24cd01f32ddf1735515a2d2e29816fda18bf9ab1c666b"
    sha256 cellar: :any,                 arm64_sequoia: "514203f5d8fa7b6fa5dea7ea0057ffd5c994e7caabb9d0c575ea05a029c7082f"
    sha256 cellar: :any,                 arm64_sonoma:  "295e57b203cdbd045a9e87a2ab1edd1bb55b579f8c33739a96b26e52a79e2888"
    sha256 cellar: :any,                 sonoma:        "ef64d067278248005c54325f7ea2be5352acdcff03bdc806806f7335e90413ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbbc10e922c3a505511ea988d2820135067c06f78c46c141614eb10f840b6aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "013eb58dd2b658edda6913edc55d20b8610fd74705960d79f8f79fa467071aee"
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
    url "https://github.com/erlang/otp/releases/download/OTP-28.5.0.1/otp_doc_html_28.5.0.1.tar.gz"
    sha256 "c2e8de86cb662c82e61477dd1bb60032391041327b9741bcebfacfb61fc684df"

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
