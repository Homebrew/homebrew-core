class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.2p2/owfs-3.2p2.tar.gz"
  version "3.2p2"
  sha256 "39535521a65a74bd36dc31726bcf04201f60f230a7944e9a63c393c318f5113c"

  bottle do
    cellar :any
    sha256 "51bd18872d4b55af34626459c3f6e039139647124abff190b280e4ddf2c4012f" => :high_sierra
    sha256 "5dd1116b1058b7eb849905b6af987e7ea71fd3486ccc8f1670cf841b6583802f" => :sierra
    sha256 "06a2b3710c371730028a58bab488064f967ef6e820f0877e723f38a4e5eaf5e7" => :el_capitan
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
