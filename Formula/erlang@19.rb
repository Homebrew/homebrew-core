class ErlangAT19 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-19.3.6.12.tar.gz"
  sha256 "f5ff65cde3f2db6f1dd61f6985136fcf87b55fa3f85e17ee513cc05dbe2da635"

  bottle do
    cellar :any
    sha256 "e70f60e4750da2244ce5a12b1f9776ec33bef8a86fa71b71a785588ef29b741f" => :mojave
    sha256 "b12f7bd72cc7a2c09e28b6633c44f41260613096d228b8e050e630a51f6190e9" => :high_sierra
    sha256 "87755fcb3dd266da40c5f4dbf28ada5ea9475faded5c8ba8d9023155bc0c8920" => :sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac"

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_19.3.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/erlang/otp_doc_man_19.3.tar.gz"
    sha256 "f8192ffdd7367083c055695eeddf198155da43dcc221aed1d870d1e3871dd95c"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_19.3.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/erlang/otp_doc_html_19.3.tar.gz"
    sha256 "dc3e3a82d1aba7f0deac1ddb81b7d6f8dee9a75e1d42b90c677a2b645f19a00c"
  end

  # Check if this patch can be removed when OTP 19.4 is released.
  # Erlang will crash on macOS 10.13 any time the crypto lib is used.
  # The Erlang team has an open PR for the patch but it needs to be applied to
  # older releases. See https://github.com/erlang/otp/pull/1501 and
  # https://bugs.erlang.org/browse/ERL-439 for additional information.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1f4a770/erlang%4019/boring-ssl-high-sierra.patch"
    sha256 "5aae52e7947db400a7798e8cda6e33e30088edf816e842cb09974b92c6b5eba6"
  end

  # Pointer comparison triggers error with Xcode 9
  patch do
    url "https://github.com/erlang/otp/commit/a64c4d806fa54848c35632114585ad82b98712e8.diff?full_index=1"
    sha256 "3261400f8d7f0dcff3a52821daea3391ebfa01fd859f9f2d9cc5142138e26e15"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-kernel-poll
      --enable-threads
      --enable-sctp
      --enable-dynamic-ssl-lib
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --enable-shared-zlib
      --enable-smp-support
      --enable-wx
      --enable-hipe
      --without-javac
    ]

    args << "--enable-darwin-64bit" if MacOS.prefer_64_bit?
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man
    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
