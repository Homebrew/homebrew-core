class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.2/otp_src_24.3.4.2.tar.gz"
  sha256 "0376d50f867a29426d47600056e8cc49c95b51ef172b6b9030628e35aecd46af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8bba53a4bda7d4e3ff51ecfa005ba52ee018e29f7e0ec1caa9a553f96186a50"
    sha256 cellar: :any,                 arm64_big_sur:  "432f429717591c1f0ffb88a85c13215d0460887ccb72fa388d0a3a3a1ac6f2df"
    sha256 cellar: :any,                 monterey:       "029547f3c55322d324039ef7bf756d8cab90d6390b60aac78d3e80ae4627102d"
    sha256 cellar: :any,                 big_sur:        "ddbf12b0bd35b7b41c6bc57818bfe8d1002d81106dbd72aa7ed7453ac563a616"
    sha256 cellar: :any,                 catalina:       "56218483be38fecaa325d484b3f0a670f04e3362631f816c596dee9b4f725b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6a33c43c322521934f6ecd657000b4bbf2d49a8673c72518138ca8027a6317"
  end

  keg_only :versioned_formula

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.2/otp_doc_html_24.3.4.2.tar.gz"
    sha256 "712ffbc37f668ff92aa35a97fbf43d4bc2ac2648fa14f3b3cbaee6c03342c948"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
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
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
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
