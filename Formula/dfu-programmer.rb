class DfuProgrammer < Formula
  desc "Device firmware update based USB programmer for Atmel chips"
  homepage "https://dfu-programmer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-programmer/dfu-programmer/0.7.2/dfu-programmer-0.7.2.tar.gz"
  sha256 "1db4d36b1aedab2adc976e8faa5495df3cf82dc4bf883633dc6ba71f7c4af995"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/dfu-programmer[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "ca50d1de0427ea337387bec0d5f277ef01337624543b02ed93e842e4d96acc17" => :big_sur
    sha256 "8bfdfd329dcd8f8590c02bd7ba062f21def25d6009dc7a546956406d921a9181" => :arm64_big_sur
    sha256 "5ff077a2c2198fc345e429246a560ca4a13fea2a9dbb9a0feb6fe4cbdfa46a4a" => :catalina
    sha256 "4435f464f3627e068fa8840ac39ec262a7d678f209292d40a2c797daddbe66e4" => :mojave
    sha256 "2ff7d2fae3995303e8b73625f5de14beaf74d3150fb1024c7bc75ca24e3a56a9" => :high_sierra
    sha256 "56775882f52597c48d0078da0488c1852fca842188f6a266cb787c9f76f3f56e" => :sierra
    sha256 "e9657f69d69597d89bd94bb1b1fc806f61a476c409a2da5a57abb062742bed04" => :el_capitan
    sha256 "4dea1ba0456ff657f6bc332db3040d1f9955a1845fcf8d34585187d67637c39e" => :yosemite
    sha256 "f7e6ab4ed28bf63c21b76917c71ada3675e312475eba15ae1f5f7a5fede3e872" => :mavericks
  end

  head do
    url "https://github.com/dfu-programmer/dfu-programmer.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libusb-compat"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-libusb_1_0"
    system "make", "install"
  end

  test do
    system bin/"dfu-programmer", "--targets"
  end
end
