class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.1.tar.xz"
  sha256 "e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "d88da4f91a77063ddb2a8bdf717c0b0ffdf552111660b1af59448d61ab465fa8"
    sha256 big_sur:       "5fb6c8719390b4728795633026c3cce062bcbc926a06200109666eb9a2c096c4"
    sha256 catalina:      "3aedff54aed6373323462945b37c69a52797e9d9b84557242176fd1e66558cbc"
    sha256 mojave:        "d04d0806c353980de4eaee8579d1d11c2b8760250ec2544bcd9914c2d9052fb7"
  end

  uses_from_macos "texinfo"

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
