class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://github.com/erlang/otp/releases/download/OTP-26.2.5/otp_src_26.2.5.tar.gz"
  sha256 "de155c4ad9baab2b9e6c96dbd03bf955575a04dd6feee9c08758beb28484c9f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c431396f5317abe1127f09e050f09b9e95b19ba1a5182a21fc5a77699bcd7e13"
    sha256 cellar: :any,                 arm64_ventura:  "110213139fc017f108a06e1f206a5ddf7272d5807c4764ead9dd5cf6db1e620b"
    sha256 cellar: :any,                 arm64_monterey: "f69832dec4aaf28bbb576bf0b6d4e09365ba9ab8e5f70116f58873db576c57ce"
    sha256 cellar: :any,                 sonoma:         "f0de0d4ee8cba0a67d9c90489fa2da82e12b2e3c4649643a8952ab88b4ec7b57"
    sha256 cellar: :any,                 ventura:        "a339941ffc01c6eac2bc0d6ef07601466573de08cb5e9765e59a56ac9168a16c"
    sha256 cellar: :any,                 monterey:       "0ca685f448bb8ea692a2f61d283420c29a82c674923f6ec408cc6ab879db19df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b2d280cd03af37844d763fb9e1c1955be8e203cc7f65271e4e65b2143b07c99"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-26.2.5/otp_doc_html_26.2.5.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_26.2.5.tar.gz"
    sha256 "7c9c99695f8b0218f655ec154954bac1d70e25fe3d54810cf81590e1eb711e47"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
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

    system "./configure", *std_configure_args, *args
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
    assert_equal version, resource("html").version, "`html` resource needs updating!"

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
