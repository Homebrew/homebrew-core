class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.1.tar.xz"
  sha256 "3ced91db9bf01182b7e420eab68039f2083aed0a214c0424e257eae3ddee8607"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "ac7ee8fe6c7db65d2dcf4fb9234282ba854ab8c0d8b514f681d589136be3ded7" => :big_sur
    sha256 "532825e20bf28d25ec96356992d91506b7cedb02912a5660754fdcc1d550556a" => :arm64_big_sur
    sha256 "219d1ead2e887b2a7f4ea9cd8b1c115dc912cd254cd678020c904d63b1810388" => :catalina
    sha256 "0e72aca9b33e17501b812660d4bdc7e692fc4a6c85e745abe47d0586e0cd6d3d" => :mojave
    sha256 "076cd5fe22328f950ac2cbf3c959c1819c9831c3f7a18f3e0fd940e83e2890f9" => :high_sierra
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
