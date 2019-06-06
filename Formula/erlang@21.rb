class ErlangAT21 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-21.3.8.3.tar.gz"
  sha256 "58e6e823ce0aa06a36d3dc0caa8b1df6475dc051a6e19f465924ae41a8c3e594"

  bottle do
    cellar :any
    sha256 "da6179c9b6f183bb3d155becdbfed7de7f85907b1c38685b08fda76b83644ca2" => :mojave
    sha256 "529cd4d8ae71121b9e8b7bd07b0ae12816ee40936167ca60f02b1f5d9f1dbe37" => :high_sierra
    sha256 "3564e8eeb21fc0cc36d8bc38613b56c9759af4af34046da9ac04833ae4174f5f" => :sierra
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
