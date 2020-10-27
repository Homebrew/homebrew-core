class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p4/owfs-3.2p4.tar.gz"
  version "3.2p4"
  sha256 "af0a5035f3f3df876ca15aea13486bfed6b3ef5409dee016db0be67755c35fcc"
  license "GPL-2.0-only"

  bottle do
    cellar :any
    sha256 "659e132d059f5b07c1f53f7ebc8676edf732da7b36f4e85065a30fe616358f50" => :catalina
    sha256 "f67044700191dc6becb4b768d2c89f8e6714411ec4182c8297edcf3d3eac1318" => :mojave
    sha256 "1812f6546d6e6957fc34aefadb1ce83ab8c7995a4c9c67b85f0ff7ba4e7e381c" => :high_sierra
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
