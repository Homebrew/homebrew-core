class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.2.6.tar.gz"
  sha256 "4cf44ed12f657c309a2c00e7806f36f56a88e5b74de6814058796561f3842f66"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "2c25292c0e3ccc02566e597ff6ec2ffac813cc1428f51f7e4f6a272c35bfd2a5" => :catalina
    sha256 "114d3b072a7959f5490982763ad37257db9e335019d591021f96627d8a56c602" => :mojave
    sha256 "d1618949378209689903f52853f6f65ec2b51ee23d44cd0d589c8c464a9eeaef" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.2.tar.gz"
    sha256 "aad7e3795a44091aa33a460e3fdc94efe8757639caeba0b5ba7d79bd91c972b3"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.2.tar.gz"
    sha256 "09d41810d79fafde293feb48ebb249940eca6f9f5733abb235e37d06b8f482e3"
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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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
