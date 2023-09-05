class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.41.tar.bz2"
  sha256 "a4c4bec052f7b8370024e60389e194377f3f48b56618418ea51067f67aaab30b"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_ventura:  "d306fde79e15534a42e29d74002e8ffd1a3a07e6d52bbf9a68b71cd31f736004"
    sha256 arm64_monterey: "89c93b9fc1c407f7ffbd430e4499173a2e29a3fd91ed3a422616e9271c8c7e0f"
    sha256 arm64_big_sur:  "ec759af2b65961d39e1ba7f1ea3e02e6ad36a9e8c315ce017620f37833b5178c"
    sha256 ventura:        "3a0933c3b448c31d2e4415289da547641bd36a941fe594884e3a181efd910aa6"
    sha256 monterey:       "a885c09f577446d22596c7f6d87e1c4e4612e77f6e790ca77f5be8bc7e0923d1"
    sha256 big_sur:        "9ff9eb1dc764fcfa54a4ecb773b405094cfa60fd9391d8f0428a6a1707a8a87a"
    sha256 x86_64_linux:   "ec5d45bba9e8d1287136d03b6ca3ac4dbae2fe4d88617eafce0604123e82755d"
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
