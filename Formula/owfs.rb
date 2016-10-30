class Owfs < Formula
  desc "Monitor and control physical environment using Dallas/Maxim 1-wire system"
  homepage "http://owfs.org/"
  url "https://downloads.sourceforge.net/project/owfs/owfs/3.1p4/owfs-3.1p4.tar.gz"
  version "3.1p4"
  sha256 "83ea34ede9f44665c5bef4e46fd9bbc087ad8a76c533bcbf03b436b7601e1e54"

  bottle do
    cellar :any
    sha256 "d2596e89c6f0a388ba62f66ca152a1c155c3992497c354eebc0701290fc82b25" => :sierra
    sha256 "63142415875279e8c5a4cdb6c54fa898fe8648570558c0f1a8d3626ad6d868af" => :el_capitan
    sha256 "7ea77ba55ee52f8bad219d904e78a708262b21ec7746bbfd02e9f70f10aa7f7b" => :yosemite
    sha256 "dd21b7a305e3469d5542c45b82b9a678eb6b5ddfb853cb835e10fc91c63dd5eb" => :mavericks
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
