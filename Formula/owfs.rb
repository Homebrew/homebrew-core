class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.2p1/owfs-3.2p1.tar.gz"
  version "3.2p1"
  sha256 "33220b25db36969a717cd27e750d73dee376795e13a5f3677f05111b745832ea"

  bottle do
    cellar :any
    sha256 "275ccc64ff6d5111d5358ca2b0f7738bb2b11e973fc5c4344117098ae45154b0" => :sierra
    sha256 "0b4b52a6c820e2d6e5be50bf7a4cd5788f0e667da84bd3ed53f4c99414eb8717" => :el_capitan
    sha256 "c83e838961245a298bbbeff2fd10833f6e316b1363f3fb4fc7e04d63fbcd45eb" => :yosemite
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
