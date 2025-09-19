class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.tar.bz2"
  sha256 "1393f90db70c2ebd785fb434d6127f8888c559d5eeb9c006c354b203bab3473e"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "5d35ae39bdf28bc71b5043ca0ee5c224a00535e9bfc991d1a2e0cb81f7c11e81"
    sha256 arm64_sequoia: "37eb2bbc064e560614b3bea589ccfc16323bf5b437befeb343869350f077b10c"
    sha256 arm64_sonoma:  "eff2bd1e8b7d29e647aef8f13a928f869f2aef7130d09ffd069b948c0d7fd5ca"
    sha256 arm64_ventura: "5ec2f35a507d2013b01cff81538308aa0feb514308f15639c01e0ae175fa19c0"
    sha256 sonoma:        "f77281da449bf026e85bca7a473ec2e16b719c7668b57ed1c4b49d6d89df4013"
    sha256 ventura:       "d0add9a330375953283e6185678a06bfb128eddb4e51a15c6a0a66bf0b8cc0ba"
    sha256 arm64_linux:   "d3c1a3f7a1d5d6a47fbd9c71065c4ffda482f270a7edc20bab5f33ea58d2bba5"
    sha256 x86_64_linux:  "c24dcc4e9b0df3bdcb68abfd9c620169ba0a30246f1c14a775f0b8fcdd9e3ab0"
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
