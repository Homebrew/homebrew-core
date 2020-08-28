class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.tar.gz"
  sha256 "a3ac62bae4f339855b5449cfa9b49df90c635adbd67ecb8a0e7f3ae86a058da6"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "743bac0fdd042088a61631b9fca121fd89d0bab810a6814448a0b70897adc84c" => :catalina
    sha256 "470b88640a1bbfafbb2bf219a9e8942ee9a0a376fa9b178a25d7edf52db63a87" => :mojave
    sha256 "cfda8211e77355eb5548d7634e97e2d7d917de459c48245af2de34d01266c2b1" => :high_sierra
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
