class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.2p0/owfs-3.2p0.tar.gz"
  version "3.2p0"
  sha256 "8e0d9697660be639cb3c9d0b780114695d1fb0f71caab3d78571ba0a7df68590"

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
