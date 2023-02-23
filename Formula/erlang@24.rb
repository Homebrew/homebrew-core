class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.9/otp_src_24.3.4.9.tar.gz"
  sha256 "f1365d55cde2aeb170fb5b25ec73dcf691ef94771b8601b61c078941e2cbd78f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6cbbf5ab6714a9cdd7255f75e494e256f6d1c98639dd44c6c3fa8c3fd7a73d1"
    sha256 cellar: :any,                 arm64_monterey: "76cffe7771e3d2f87035e42ebd7a558169dda656fb4be19205c65956b26e77a1"
    sha256 cellar: :any,                 arm64_big_sur:  "6fb4c451517568263ad1881f0db9601ca8f597a5262f7f652947ccbd3dff2dac"
    sha256 cellar: :any,                 ventura:        "b46f2207e81a9d53dcca3804dbc679d16549bebd7395a3c97d7b57e4bf99d6b2"
    sha256 cellar: :any,                 monterey:       "0b9912012dc62a9eb133c36379cd87fecb97e57e833025b8c320d1a914f99946"
    sha256 cellar: :any,                 big_sur:        "c3e000836570f25a496bcb4e65a1f5f0ec815142add910750aa9097d4e9f151e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c214c21aee7540723fbe8f73152f96c4a54fd11e898182528a51c99c732127ff"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.8/otp_doc_html_24.3.4.8.tar.gz"
    sha256 "0627f8efc6566d579c3e7107307b663cb955e4d194ce05aae68a8f1f2dddc01f"
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
