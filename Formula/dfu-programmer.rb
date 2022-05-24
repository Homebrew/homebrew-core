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
    sha256 cellar: :any,                 arm64_monterey: "9559a215bd458ba59d0b037792b7d63dbc3dc4c099b14357e8e53acb5d3af922"
    sha256 cellar: :any,                 arm64_big_sur:  "8bfdfd329dcd8f8590c02bd7ba062f21def25d6009dc7a546956406d921a9181"
    sha256 cellar: :any,                 monterey:       "275aa114a5df563a91342de289d313bf2fdf8a3d85ce77417818ec8fe8fea05a"
    sha256 cellar: :any,                 big_sur:        "ca50d1de0427ea337387bec0d5f277ef01337624543b02ed93e842e4d96acc17"
    sha256 cellar: :any,                 catalina:       "5ff077a2c2198fc345e429246a560ca4a13fea2a9dbb9a0feb6fe4cbdfa46a4a"
    sha256 cellar: :any,                 mojave:         "4435f464f3627e068fa8840ac39ec262a7d678f209292d40a2c797daddbe66e4"
    sha256 cellar: :any,                 high_sierra:    "2ff7d2fae3995303e8b73625f5de14beaf74d3150fb1024c7bc75ca24e3a56a9"
    sha256 cellar: :any,                 sierra:         "56775882f52597c48d0078da0488c1852fca842188f6a266cb787c9f76f3f56e"
    sha256 cellar: :any,                 el_capitan:     "e9657f69d69597d89bd94bb1b1fc806f61a476c409a2da5a57abb062742bed04"
    sha256 cellar: :any,                 yosemite:       "4dea1ba0456ff657f6bc332db3040d1f9955a1845fcf8d34585187d67637c39e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e92b3de2d143401517c149f42de3acd6f2d64bc779ed515f7f89ac5fadb1fe9c"
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
