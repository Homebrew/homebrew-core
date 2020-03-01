class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.gz"
  sha256 "53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3"

  bottle do
    sha256 "14f878d52bbfda63e4ad9b44134b894158f6a3ec88f4c030df82611ac48deb3d" => :catalina
    sha256 "aa128109b9f8b978f645fe87cc65b1e168a6360aeec53bdd158755044285f150" => :mojave
    sha256 "1c5175cd3d2c944a752a7a6322fa545971a6211fb30cf358f8c49c02155bc923" => :high_sierra
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
