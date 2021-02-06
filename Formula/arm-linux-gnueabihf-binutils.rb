class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.tar.xz"
  sha256 "5788292cc5bbcca0848545af05986f6b17058b105be59e99ba7d0f9eb5336fb8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "91344b354b969486b4c8f941da0088f99fb5cae9aae060cf873fdd8e654f26c8"
    sha256 big_sur:       "471292a385af21149fe0236e61e7d7e0f7b98f339fe1591e3ba85f97d8008ce4"
    sha256 catalina:      "bf12f413c20355ed062998979a61234933e1710d509a021e54f71a3b730590a5"
    sha256 mojave:        "39970ddd1f19a06664d5d1edd3f938776a71dc031e4b7069392940cb77731401"
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
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
