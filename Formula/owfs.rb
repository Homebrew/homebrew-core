class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.2p2/owfs-3.2p2.tar.gz"
  version "3.2p2"
  sha256 "39535521a65a74bd36dc31726bcf04201f60f230a7944e9a63c393c318f5113c"

  bottle do
    cellar :any
    sha256 "2f872a0f0a40292f084428d6dd6f94a422459f6ea23b03c7f67dcdc8d99c45c7" => :high_sierra
    sha256 "fdf50be604059bacaff7c94ea0587955ba76f8c1e3305241fa1f8d66ae7086ba" => :sierra
    sha256 "8681c47d096361bba2ffd375b60b303b91a843f61eacd16584ffe75d1710bf39" => :el_capitan
    sha256 "297c63f6ab46b17599d77e05b70c383732a7b2cbe70ce3f78c5cc802ee635f43" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--disable-owtcl",
                          "--disable-zero",
                          "--disable-owpython",
                          "--disable-owperl",
                          "--disable-swig",
                          "--enable-ftdi",
                          "--enable-usb",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"owserver", "--version"
  end
end
