class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"

  bottle do
    sha256 "133d41e8d94e272a87b71ee4f73c35aa954a38de1b13d9340b9756f56c62cc7d" => :mojave
    sha256 "7603bd2dc2d5ff4ee8671ab3444d0d20d4f907fbb469fe3cd628540f68caf1ea" => :high_sierra
    sha256 "e7179a5847a494bc9e141f6a863d3b4912c71981686e1a456d2368431a9ae33a" => :sierra
    sha256 "4b727d9fc8ffe961eb071e69430367e217be6bd3d967d66960ad1903fe2b9ebf" => :el_capitan
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--disable-werror",
                          "--target=arm-linux-gnueabihf",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
