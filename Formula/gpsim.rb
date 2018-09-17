class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "https://gpsim.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.30.0/gpsim-0.30.0.tar.gz"
  sha256 "e1927312c37119bc26d6abf2c250072a279a9c764c49ae9d71b4ccebb8154f86"
  head "http://svn.code.sf.net/p/gpsim/code/trunk"

  bottle do
    cellar :any
    sha256 "3d31846ad5fc739d011a522728ec92ccb17a5103a287500abe97b6f33087e794" => :mojave
    sha256 "8aab95ce27710fb23c55f3a772ca389e47cbcbb011954532223a9e4519f0c538" => :high_sierra
    sha256 "734a058b83a8636d7cac14f03f141ab949e7bc17abb5685747b188e27f1f3e2a" => :sierra
    sha256 "9b669b415d26e4efe157ed3d2f5f34ff8af6ce2811bbb732aeea46af7f290e94" => :el_capitan
    sha256 "4049efd02de96753275cfb5119efc843d1da0eba30f314b7b2b3e4776b5cd430" => :yosemite
  end

  depends_on "gputils" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end

  test do
    system "#{bin}/gpsim", "--version"
  end
end
