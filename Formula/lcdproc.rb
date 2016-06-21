class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://downloads.sourceforge.net/project/lcdproc/lcdproc/0.5.7/lcdproc-0.5.7.tar.gz"
  sha256 "843007d377adc856529ed0c7c42c9a7563043f06b1b73add0372bba3a3029804"

  bottle do
    sha256 "2a7bd5effc794f54e2364b74caba344f949a288b4ae67e55e829e6256a585732" => :el_capitan
    sha256 "7ed7e364837c7f0c3702d522d3dd8f73de0bd06fed5bd27c9010975042337ca7" => :yosemite
    sha256 "2a1f1649eeab5698d37280c86e8d7ec935a99a48e3d844d9f366beea431e5175" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "libhid"
  depends_on "libftdi0"

  # Fixes build failure "error: unknown type name 'uint'"
  # Reported 21 Jun 2016: https://sourceforge.net/p/lcdproc/patches/26/
  patch do
    url "https://sourceforge.net/p/lcdproc/patches/26/attachment/darwin-uint.diff"
    sha256 "174a812f325bf60f801252ca1d680b1b781ae421ae54066b699276905423c7e1"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
