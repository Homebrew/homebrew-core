class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"

  bottle do
    sha256 "2371b10dc3bd2644ac83ced35dcde1960110217385f9f5547917ebbbb823e332" => :sierra
    sha256 "1de4bece6e781dc6d88d000039095cbf6edbd10313163ef9644152d67778171c" => :el_capitan
    sha256 "2ac794ede644c1c86b321af648eb2b0197762cb7e5eb09cd0a31e8eed842e2f9" => :yosemite
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
