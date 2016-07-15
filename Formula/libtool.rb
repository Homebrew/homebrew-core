# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"

  bottle do
    cellar :any
    revision 1
    sha256 "b3ecfcb96cdab58b4916e60f8c51b79396f6fad9572812a5f84a5b3c0ad68304" => :el_capitan
    sha256 "07701b3a36b601c6489d5398200a4c86fa98fef90bf045f0bec0dc6ade73cf6a" => :yosemite
    sha256 "b675800040bcf5d554e30ea03a91a00aeae2417895fcd2dea6d0fa550748cb20" => :mavericks
  end

  keg_only :provided_until_xcode43

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end
