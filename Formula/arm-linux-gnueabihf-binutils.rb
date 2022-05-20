class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_monterey: "729928ef4235b88356212ad30314b0a5543133b87d6a269bd16e609f853d1bc5"
    sha256 arm64_big_sur:  "affec31d67e52ebf0356255ee7b0b898f333e6019e11cc9004878116ffa266b8"
    sha256 monterey:       "f3d38b79845de8e16ae966af77f55ec09b137f28731c82b06af0c56bcb94525a"
    sha256 big_sur:        "00e3c86d150d5b6f31b4ac2b62690a3df9e241a4e35d8f2a5ccbee115873829c"
    sha256 catalina:       "e7e27fc6eaf46d76fa75111061e6e94b43cda5c3d121b4e9bb4ba946b2f1b501"
    sha256 x86_64_linux:   "d95ef9a584dec102bc33909ff25ff80e32f6f064f2d9da4b4a85a1ba873ac190"
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
