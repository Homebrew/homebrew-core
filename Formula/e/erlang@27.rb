class ErlangAT27 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-27.3.4/otp_src_27.3.4.tar.gz"
  sha256 "c3a0a0b51df08f877eed88378f3d2da7026a75b8559803bd78071bb47cd4783b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(27(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bff7f023ddbac233d5353e01a12078785a9b385f751589f17c8c89014040b80e"
    sha256 cellar: :any,                 arm64_sonoma:  "410d02810f2aec83e88b3e56c0b9c0d3244c142fa9ce358631447f36b3a065c8"
    sha256 cellar: :any,                 arm64_ventura: "6a3f201760e3a3e5d4f60d33fb5206d973951ebdf70fac185b7b68813d7bca15"
    sha256 cellar: :any,                 sonoma:        "39e25930331da9aa9ed78a45705a8674b8c8043ebe89af7753537f6f367758bf"
    sha256 cellar: :any,                 ventura:       "5b303edce6fd77cfda7128a7d1a0a363fcbbebe65c5900442ddba32f282d95a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f52a6c317ef6cdd39d6130e09168561181a7280f933516bbddb83005301260b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee5948660a01bf6de0f81e29328a681e4e9de81431a59fd61364ddb874e99fe"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-27.3.4/otp_doc_html_27.3.4.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_27.3.4.tar.gz"
    sha256 "58e0110a4fbcd8ad5ae4bace64a8082135e4ed19ac88d5fe9763bee6244c84d1"

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

    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

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
