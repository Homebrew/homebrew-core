class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p3/owfs-3.1p3.tar.gz"
  version "3.1p3"
  sha256 "81460ae8aab4a5cf2ff59bc416819baeacdeb1b753bc06fd09d6e47cef799be4"
  revision 1

  bottle do
    cellar :any
    sha256 "bcd519417cad17e0827e8819a30088a7f321ddf6fab8aba019e9404273bd65ea" => :el_capitan
    sha256 "6fd1ef8f6613ef629b68df76a40444899a3d1a58f66d9dcccfd2219b4f2b4837" => :yosemite
    sha256 "06bf0308576ec7e5ba3b8843f87b6932fbc521b3f4f5d46264f4bd453bbe3cab" => :mavericks
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
