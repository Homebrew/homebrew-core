class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.37.tar.xz"
  sha256 "820d9724f020a3e69cb337893a0b63c2db161dadcb0e06fc11dc29eb1e84a32c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "5a659a38444d82e79e8f6257fc1d5c7356f17089ce294b2ff843ea3000bb3e60"
    sha256 big_sur:       "00bc33303a003f4b14b68a4ffedf08ad6d271a90701ac3fe1f4c826a315ec017"
    sha256 catalina:      "90b2ed05b009b7e4f62e7eb123dbe16caa6feab3bef16b60617136b1c834cad7"
    sha256 mojave:        "583c8e1990736b9b6e7ccf5b6a1b6042bf6a63e4de45bb840a247434dfedd923"
    sha256 x86_64_linux:  "73438210ebc0a798c7607dd7366cfb3cd2321691a6d52d4201d0d0349587a085"
  end

  uses_from_macos "texinfo"

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "arm-linux-gnueabihf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
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
