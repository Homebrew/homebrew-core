class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.2/otp_src_25.2.tar.gz"
  sha256 "aee1ef294ee048c976d6a126a430367076354f484f557eacaf08bf086cb1314d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "37d912375212f286c839bcfd774ea7670e501652eea3dc83765f1aefa196aa9a"
    sha256 cellar: :any,                 arm64_monterey: "532e2a650c862cb0766c423844a716c2c0726b7203956181d8e0b6331cf552b7"
    sha256 cellar: :any,                 arm64_big_sur:  "04a7abbb560e4ffefbb8a7455c93fd36fe9eee7bc89518bf01805007fb2e2a0b"
    sha256 cellar: :any,                 ventura:        "2fc528ecfa1c07dd81577573c204ebbb522a237d04bc8f0ae1096c1345972763"
    sha256 cellar: :any,                 monterey:       "f704ed38fc962a8035cf1140133b86255c03347028e28f251cc9dc76e92451fc"
    sha256 cellar: :any,                 big_sur:        "95544542d3892e2e03207487af72dee4d107e6cf951f49ceeca40907db38b9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa5e092f9ae72b0f5ee0577560a13996e9b55507c8638ee1dc171bf6af84870"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.2/otp_doc_html_25.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.2.tar.gz"
    sha256 "b08e933e4d8753039dfa03c47daec30f7a9194e5e41b8c3c318c6c95d861b252"
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
