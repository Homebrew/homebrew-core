class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "c64ae1f287f091d817bfb6652f1d344d479f828d913f95150cd24dc0b55b58b7"
    sha256 arm64_monterey: "7d8bd2f8bc29a789978bdb0f18aca064b5602a4021ebe3bde182275d96747ef1"
    sha256 arm64_big_sur:  "98b27eb2768454706840805d1bfcc35aad5721c96e296150c26e45820fc2039c"
    sha256 ventura:        "35c178b570359bdf49e609783af569e304ff8242f7035b5aa8ea02ed2530d0c4"
    sha256 monterey:       "f2fb94a14bc2a0a75e26297455332bc32a327cd382cdf5a6164cc94f1b1905be"
    sha256 big_sur:        "e70d7a7c9db95884954f18a7652017c83002465f8466cfbb95ae91edec873f74"
    sha256 x86_64_linux:   "fa4359b2a440212ebf5c7739e46d14ab28f2787bcd462f25914ff37c0c7a97e4"
  end

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

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
