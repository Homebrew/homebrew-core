class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p3/owfs-3.2p3.tar.gz"
  version "3.2p3"
  sha256 "b8d33eba57d4a2f6c8a11ff23f233e3248bd75a42c8219b058a888846edd8717"

  bottle do
    cellar :any
    sha256 "9873bebe0313c3bcf14435552914e70d3f44e42c40fb8740a110fee6b7a31d48" => :mojave
    sha256 "5ce68ea75761ab29c718d7eb584dd305f76a3689faf0ede10e4e548d9270cf8c" => :high_sierra
    sha256 "f8fe6f4b969682f9a4f1238b5b3cbca74cf49daa6915596a51135f559bc2f450" => :sierra
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
