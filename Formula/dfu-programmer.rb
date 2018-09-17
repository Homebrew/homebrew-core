class DfuProgrammer < Formula
  desc "Device firmware update based USB programmer for Atmel chips"
  homepage "https://dfu-programmer.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-programmer/dfu-programmer/0.7.2/dfu-programmer-0.7.2.tar.gz"
  sha256 "1db4d36b1aedab2adc976e8faa5495df3cf82dc4bf883633dc6ba71f7c4af995"

  bottle do
    cellar :any
    sha256 "4435f464f3627e068fa8840ac39ec262a7d678f209292d40a2c797daddbe66e4" => :mojave
    sha256 "2ff7d2fae3995303e8b73625f5de14beaf74d3150fb1024c7bc75ca24e3a56a9" => :high_sierra
    sha256 "56775882f52597c48d0078da0488c1852fca842188f6a266cb787c9f76f3f56e" => :sierra
    sha256 "e9657f69d69597d89bd94bb1b1fc806f61a476c409a2da5a57abb062742bed04" => :el_capitan
    sha256 "4dea1ba0456ff657f6bc332db3040d1f9955a1845fcf8d34585187d67637c39e" => :yosemite
    sha256 "f7e6ab4ed28bf63c21b76917c71ada3675e312475eba15ae1f5f7a5fede3e872" => :mavericks
    sha256 "a1c904a689bc6b175ac3f2ad2da6d53e11039f3ce55efee77fbcfece2f9e2c24" => :mountain_lion
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
