class DfuUtil < Formula
  desc "USB programmer"
  homepage "https://dfu-util.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-util/dfu-util-0.10.tar.gz"
  sha256 "a03dc58dfc79c056819c0544b2a5970537566460102b3d82cfb038c60e619b42"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "253ae328a68f4f61eab3f13e273ee7795fe121597f226a0b74cdf851c12ccb0e" => :big_sur
    sha256 "742ed4829d01efdb37854b29e5f2199b4674b310cdad87f8cfdbeedc3ed97c7e" => :catalina
    sha256 "811d4e5d574bf5d3cb8783374927c6861c083e05711f538925a819490c5a49c7" => :mojave
    sha256 "c1e5f33cee759c8273ed5b9088262c442773342378939cecd374c99889126f8b" => :high_sierra
    sha256 "3b9f9f6cf990becc1f2979fbec2cf2833d6f0ee2ab1ba3db4979203f1d591ee2" => :sierra
    sha256 "49975a34b6bacad4549871097effce90e376d3cd26ed24b2d7dfd925a199f0f8" => :el_capitan
    sha256 "776c3ed14def87511f9280201a95490145a9d469e2c1e29873c335e2c39ed279" => :yosemite
    sha256 "75c7ffa4e2d5067618c41f999f3d0c8a9aac1080e9eb8cd1f9bec8dd154aa1c1" => :mavericks
  end

  head do
    url "https://git.code.sf.net/p/dfu-util/dfu-util.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dfu-util", "-V"
    system bin/"dfu-prefix", "-V"
    system bin/"dfu-suffix", "-V"
  end
end
