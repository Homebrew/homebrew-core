class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-25.0.3/otp_src_25.0.3.tar.gz"
  sha256 "0d7558bc16f3e6b61964521e0157e1a75aad1770bb08af10366ea4c83441ec28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8b515e9ff6051878359ea7d3c8d68224bd0ba1eb1fb112bae7fda19ea1640681"
    sha256 cellar: :any,                 arm64_big_sur:  "db9ea131b9f0596e97da110cb1ed3d376d70a6a70ff95b3a0187a1bb601547bb"
    sha256 cellar: :any,                 monterey:       "35a54845ac66df92309bfcf6f45be0e8b791b2663021b86e1ccbfc3549bc9640"
    sha256 cellar: :any,                 big_sur:        "61add4c3705ffda2ff9dc41564e67ba7cf4b3b14be9e4e0f059a7e4d9bf0c856"
    sha256 cellar: :any,                 catalina:       "f50ac6b34b93cf4ef9e26ff1abc969cbf99138fe3d26bffee7af5f38ce25575d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a01ec9a6ce262a3ca14befa4fb6442bf8167d40bb10f408bce5497d24496ec99"
  end

  head do
    url "https://github.com/erlang/otp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-25.0.3/otp_doc_html_25.0.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.0.3.tar.gz"
    sha256 "59bac9849eb262c9cac1fa7d4bf1e82cfbea23e453f074f1f3582a41545303dd"
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
