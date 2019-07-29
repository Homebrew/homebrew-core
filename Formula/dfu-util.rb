class DfuUtil < Formula
  desc "USB programmer"
  homepage "https://dfu-util.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-util/dfu-util-0.9.tar.gz"
  sha256 "36428c6a6cb3088cad5a3592933385253da5f29f2effa61518ee5991ea38f833"

  bottle do
    cellar :any
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
