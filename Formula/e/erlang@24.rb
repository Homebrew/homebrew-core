class ErlangAT24 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.13/otp_src_24.3.4.13.tar.gz"
  sha256 "111a00cf3fd512526e35f232fb18e6e95c7a9b1688bb38d7dd8152a82e0ea684"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(24(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0bfc3723c7a5c97f0d32e76472e314b09a5e69c73bf9b35e21139fa197fec769"
    sha256 cellar: :any,                 arm64_ventura:  "2dc01b89db2837caab9908c4eefd4818a999d7b64a2699ef7058b688c896ce75"
    sha256 cellar: :any,                 arm64_monterey: "51acd2d297d04a6b4c6fee883efb47f806f690cfabf27b30065627e4847b786a"
    sha256 cellar: :any,                 arm64_big_sur:  "e3133307556462aef05995e52af4b9ee11423ae69ed29c513a23dfbbf364ff4d"
    sha256 cellar: :any,                 sonoma:         "1fa9916870ed718644025cb16ae82bfd1d104482c6fa3dd26a8f47dffe4e37d0"
    sha256 cellar: :any,                 ventura:        "7fc45e9860fcef5ecc45234a2379a4ea37498237d26139628e9907001f6a2840"
    sha256 cellar: :any,                 monterey:       "78c0aed31bf5a592a66b57cb6baeec0d0b9d6e80abeab178e50d46a3675be90f"
    sha256 cellar: :any,                 big_sur:        "6f161623575275acf4bba67262b0e7e3d77584ccf1c83c8f7371bd9a1c6044a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d9cd64e9faeef0344d72900812b11353b22d59e8468db795f6a29e98e84d57"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://github.com/erlang/otp/releases/download/OTP-24.3.4.13/otp_doc_html_24.3.4.13.tar.gz"
    sha256 "b67e42d703dff130b3891651d852e08dfc97cf7a13da5e2287ca2ecec7d36cab"
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
