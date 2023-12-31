class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sonoma:   "ae60dae148c0c903a5ebc57282c6df9e9aa76161bb9311a73a3f943bb0f4806b"
    sha256 arm64_ventura:  "e9f62b0f3c7aa06bf858df99dd38eabeae6bfba9234b360dfb58f7c3118abb7c"
    sha256 arm64_monterey: "e5a90266cf3b3e347a8b5242e6b4bde64b443bbe168f7c0798e7d920d7fcc522"
    sha256 sonoma:         "9afcd8cb32f113be993b15702f753e676bfb21f9c48aed4bea4362e686a83dfa"
    sha256 ventura:        "995f49001c59c1a31a69921a4a727d5ca91de826b76f2c11987f5fe4d979abdd"
    sha256 monterey:       "55080e306990e4fac4832b7ad39e6de6b56703ddddb44cc298c9f1d813c2be2d"
    sha256 x86_64_linux:   "2e2a57cfe8267debac6a4b28022fa6329f64232b5b47797dd1e49e0ff539a9b6"
  end

  depends_on "pkg-config" => :build
  depends_on "zstd"

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
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
