class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 monterey:     "0184f9e8d0715ce4a16b47546ba9e9b60c9cd180b8bbc1144f45b7989e893eeb"
    sha256 big_sur:      "d7322da651604d5d79ab0db17f80d51b6ef3c53da0ca69b798554b51bc7d117d"
    sha256 catalina:     "e640f1a3d299eee6557216f4d07666f810f81ec4f7c2da4de9ea2906cd562be7"
    sha256 x86_64_linux: "fedfc8c4e62e7a0c63004ab84d1310162950d6ea2b065a46d63e2f9991617213"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat" # Remove when all drivers migrated https://github.com/lcdproc/lcdproc/issues/13

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
