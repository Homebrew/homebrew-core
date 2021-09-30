class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.10.3.tar.gz"
  sha256 "7b5f21989afdd9cf63ab4a2df4ca398782f24fda2e2411f88188e00ab49e3069"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "5f99ba4a0ff227ff1ab95201f5064e334612001af2dd1d9bd2d178d018142759"
    sha256 big_sur:       "ff79aca1e58097d1eda8e2bd0b67d76e897a4146b1be0355adb38528911ec526"
    sha256 catalina:      "0c663487948a3090f30bb2f9d034132c9c5ff7c034efc703c49746d573e22d45"
    sha256 mojave:        "5a8264996840f6844933633f245463f7d6c7a5c625d6688a89083a393d04f650"
    sha256 x86_64_linux:  "f56550e600a49e15e7e86b6adbd6fc9ec21d8e3b248588449f9df0ac1e2047be"
  end

  depends_on "open-sp"

  def install
    ENV.cxx11

    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
