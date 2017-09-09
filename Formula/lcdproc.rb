class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"

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

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
