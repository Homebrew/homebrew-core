class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.12/otp_src_25.3.2.12.tar.gz"
  sha256 "fd690c843100c3268ac7d8ada02af8310e8520bf32581eb72f28c26ae61b46ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d47fe36a81d566fbb44988954f52813c43bb97fd5e2ce65bc713937d00edbe21"
    sha256 cellar: :any,                 arm64_ventura:  "be3609d4f9eaf8b05e3cf8fc2bcd19e031bf18f34ba807bef901cf91f4009504"
    sha256 cellar: :any,                 arm64_monterey: "e2e194aee78320926ffbb2858f6f149354859e8f0c16949b2b02af2d666046ac"
    sha256 cellar: :any,                 sonoma:         "dc50819547e59b4c3c62ac7a68c180629110eb9dfb6bbc9ae9f3de32b7af173d"
    sha256 cellar: :any,                 ventura:        "16d0a08170b2edf0d9c9083a5d7971557e4b67ca491340dae694f6527556b762"
    sha256 cellar: :any,                 monterey:       "4df2e4918fcbada8edd90fb261be57783a03aabe16cafb3b4ea42af362010993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6a32742dec7042114558bca3e23b2d49e098d0d5cf44e93f37c45e4ff530e86"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.12/otp_doc_html_25.3.2.12.tar.gz"
    sha256 "36ee489626935d6148b82d721267221d32d44456dc58cbfa23f9f340e448a00f"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

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
