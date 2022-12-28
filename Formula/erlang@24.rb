class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.7/otp_src_24.3.4.7.tar.gz"
  sha256 "0cb1092f6aff83e8026acffa020dfcffb91073e559311ee1681fdec2d0e15e2e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "eaabf75d9c9a57137c478bd1de82f6c7a236f0abcac889787827cabee69174b4"
    sha256 cellar: :any,                 arm64_monterey: "85ee696b9ef60dc586b7a1c722f5385b7c8bfc7bea8fb6a4581c346a7d3fd6b4"
    sha256 cellar: :any,                 arm64_big_sur:  "85ac822b8f17236a324a8d8439fba06c363d1b59ecf6f5dcbaf3456a55abfe74"
    sha256 cellar: :any,                 ventura:        "ad7a3563a55c3f4d90f975bd803cd7b8b4b9a78bb9bf012954efadb559b87fd9"
    sha256 cellar: :any,                 monterey:       "5a032ed7e3bc13c38f0a0432490745508b3f938a1c126f1c180646ded6a1d9ab"
    sha256 cellar: :any,                 big_sur:        "eed954cb643e66df118e7616cafa2102e344a7531ac8c68d7f7de0716a545c47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdaafb682a61c8d17fbfec7150ec41a0faeaef8dace58adc0efc2498b854cc36"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.7/otp_doc_html_24.3.4.7.tar.gz"
    sha256 "37fb272117b449e597a6c9a0d8a0b80a854a3020bd1fc0a62325ceb895005670"
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
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
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
