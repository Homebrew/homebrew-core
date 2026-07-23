class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.1.tar.bz2"
  sha256 "324ed40ada2633a28eaa5d104ca5db165fd3cc3162cc1d48a7b7fa9c932da439"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "ea8da9b83c4ed426401f0c5bf8760c07e7688c2c99e638532456d8e2d6c61a3d"
    sha256 arm64_sequoia: "093e705e2cc49c1b7b412f99f5e496ef26f3358ef0376fb97fcc977069bf32ea"
    sha256 arm64_sonoma:  "d32f9f30f47e9fdab86d70ac234324d037a793a312829a27bcc122c22091bae3"
    sha256 sonoma:        "8ae65b7897a8f1b1fa375b4c4ed0b9c8ca5523605e68b987863eec55f8785328"
    sha256 arm64_linux:   "651004348742ada8e6036d83f4a3b45a5faa47a35bbf7f2a3c0d241b8198b263"
    sha256 x86_64_linux:  "b9fa9cf335761569d21cda1c25dc58068b34e7d00c4b6360c6e36ef4f5f434dd"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_macos do
    # Requires the <uchar.h> header
    # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
    depends_on macos: :ventura
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
