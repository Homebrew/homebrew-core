class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "https://owfs.org/"
  url "https://github.com/owfs/owfs/releases/download/v3.2p3/owfs-3.2p3.tar.gz"
  version "3.2p3"
  sha256 "b8d33eba57d4a2f6c8a11ff23f233e3248bd75a42c8219b058a888846edd8717"
  revision 1

  bottle do
    cellar :any
    sha256 "2b3d52a12424dddee938a0fe9a4620938b4c01a0989f68f34efb5eadb2098bcb" => :catalina
    sha256 "118ad185bc83ac080c485e1572c5dbf9118c5620a89076e7c2715a45f07684c8" => :mojave
    sha256 "63f73726171fbc413a80a30581a604a68f6371d05d86db9a848d1ddbf5cb7913" => :high_sierra
    sha256 "76c620684afb471f5d348badbc1c7429054b348c8ebe4a8c4f70b02b3ab26374" => :sierra
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
