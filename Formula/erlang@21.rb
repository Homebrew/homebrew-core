class ErlangAT21 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.3.8.5.tar.gz"
  sha256 "5225db77d313c41a097868d5f8ea7918f6d3beb4339efc99640c8dd227a0ba80"

  bottle do
    cellar :any
    sha256 "cea4f9bd7b88493cbaa37b7a4697b07c7ea6237f112618f73e0e8e31408663f7" => :mojave
    sha256 "63987f0e5e4c65426454f8b49285c39cfece5881f5d623d5b896b2c27343c4a4" => :high_sierra
    sha256 "c7ebaeca6da560f11c81f0c89c181b16b0384887863c1823a2d2c5d3a0b4dd2b" => :sierra
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_21.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_21.3.tar.gz"
    sha256 "f5464b5c8368aa40c175a5908b44b6d9670dbd01ba7a1eef1b366c7dc36ba172"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_21.3.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_21.3.tar.gz"
    sha256 "258b1e0ed1d07abbf08938f62c845450e90a32ec542e94455e5d5b7c333da362"
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
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
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
