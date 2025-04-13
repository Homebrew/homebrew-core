class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.44.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.44.tar.bz2"
  sha256 "f66390a661faa117d00fab2e79cf2dc9d097b42cc296bf3f8677d1e7b452dc3a"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "efa4af7fe2a1f1af0532a7eba01be51b606d532428364e57abefa1e0c5251b05"
    sha256 arm64_sonoma:  "f8c07d9d101a620317cf2b25f6544a9faa9e59756645dd1a252dd4f3b404e492"
    sha256 arm64_ventura: "85c571a268fffa11b63163d14d3531e226c30a012e9dfeaf05cd0f0702528617"
    sha256 sonoma:        "a5122cdafdf344088a2a34974e209a9c87a54c99f17bee9ae84119b0a6e31a82"
    sha256 ventura:       "b5d1a4cacf725353dd20a829c3f79a41803b1d680d58b7db77c3ae526a0ed7e0"
    sha256 arm64_linux:   "4ae1d9653da02773fb59e33fea7fefc3071fcc35bae702b4c906ef8031d49362"
    sha256 x86_64_linux:  "3af94c9946af90084949b00786c4273721977bc466bc69a24c515b4b18d15d50"
  end

  depends_on "pkgconf" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
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
    system "./configure", "--enable-deterministic-archives",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
