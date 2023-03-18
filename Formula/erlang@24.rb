class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.10/otp_src_24.3.4.10.tar.gz"
  sha256 "18a58b889b62dceb7ad0d2904c02edcd66f8971e46d6a86cfc296f9f5155ffd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2aba1c87738cdee7dc4c5b4ea37b544a8ce76e4893d04d9316461b3643d29b93"
    sha256 cellar: :any,                 arm64_monterey: "751dc970e54701e69aea933bf24817bf3b26d886fee8f154d2a430baae06e674"
    sha256 cellar: :any,                 arm64_big_sur:  "06a80fef31fb6ba45906f8fe39726be26d5c211ad3d20590292d242fc512e2e5"
    sha256 cellar: :any,                 ventura:        "aef30c772a0adb3769ba4cf1936ba46c78b671eab0d23e427b0d0a7645617225"
    sha256 cellar: :any,                 monterey:       "f93c5aff4a0345edd66fb321ae3d3e9f51da104acb1ffb48eef5e9131461c664"
    sha256 cellar: :any,                 big_sur:        "e08eb6c3b6892484a4fe36fb0ff9217544dcd8c5936c99a10069be8d47686625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c21f84ad68e1a49a342c9fc1c81aa3fb7de0225c81617486572e89dad91f1d5"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.10/otp_doc_html_24.3.4.10.tar.gz"
    sha256 "bd25a9727adb1fc688a4c516f65d27be551af5718c039c1a36475b11ac8a0e0a"
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
