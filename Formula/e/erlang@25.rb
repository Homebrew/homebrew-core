class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.20/otp_src_25.3.2.20.tar.gz"
  sha256 "9dda848291428c02d8373f32da5dabf7c1a1478d9cba268fa85475eb26371fe7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d753dc65e9103dc8a07627199638fe7de5f15b70798cc44d3bef25ac8dc2d8d3"
    sha256 cellar: :any,                 arm64_sonoma:  "2af990d56abc88f6cc2673f81ec3ee40bce29dc47cfa744eba9ba64e929ff127"
    sha256 cellar: :any,                 arm64_ventura: "71ad0cd098a67f5c7c69aa04481bbb70a97396cbb890c619b02542bd1fc8b969"
    sha256 cellar: :any,                 sonoma:        "79985c4956312221cd46f8a5611dc8d3641e3ad3e3f1134521e1f78f622b3091"
    sha256 cellar: :any,                 ventura:       "286a6eea3e9f7db995f19f49ce5d3e96fe2c41eb100a49de5288b90d1f69562f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edd2d6bff91bb6f435ddb548f06c3a429d09d3b38c8c266196c9d8a1b78ef03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433bab3850a4c33bd19514fcd4557d24444a7973a7f7e19328adee014fc4e550"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.3.2.20/otp_doc_html_25.3.2.20.tar.gz"
    sha256 "8ff5f2159fed059fbc7addce7b18f83b5e43d77f4a74b4dbb1f0f9c26a5c4ccc"

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
