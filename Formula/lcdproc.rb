class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://downloads.sourceforge.net/project/lcdproc/lcdproc/0.5.7/lcdproc-0.5.7.tar.gz"
  sha256 "843007d377adc856529ed0c7c42c9a7563043f06b1b73add0372bba3a3029804"

  bottle do
    sha256 "c46b64b6eb8f3c183ac2bbcde765762132a19547b9670c268256b419a9202468" => :sierra
    sha256 "e1008387529718eb94cf0c886fc03ae2ffa98d56cab19d7e86148b1de811e4ae" => :el_capitan
    sha256 "1768dad06b78f2dd815e8f1c270016e89db964abdc8fdfbe21710305e2e5f951" => :yosemite
    sha256 "e7666856c50e76fd2eb9877669ad0e233f6417cf897cf7ee4296b85a38e3cac3" => :mavericks
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
