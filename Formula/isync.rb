class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "http://isync.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.1/isync-1.2.1.tar.gz"
  sha256 "e716de28c9a08e624a035caae3902fcf3b511553be5d61517a133e03aa3532ae"

  bottle do
    cellar :any
    rebuild 1
    sha256 "76ed1f0a0d407d27870f7beb51c38275e6034b1c3c74ee0f3628e08fdadf6607" => :sierra
    sha256 "38fb0d21a245178886acb1262f57ddde284adbf889039baf3401bf2028d7cba7" => :el_capitan
    sha256 "074b9295e7ac9773eafac5bdc20e32d42d8023ffccd275235d0cb72ff09574cf" => :yosemite
    sha256 "147097d617448be4d6796bf189a05200c1afd738ad64fe05aa40c61db10b5194" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/isync/isync"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "berkeley-db" => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]
    args << "ac_cv_berkdb4=no" if build.without? "berkeley-db"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
