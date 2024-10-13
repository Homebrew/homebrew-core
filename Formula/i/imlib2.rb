class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.12.3/imlib2-1.12.3.tar.gz"
  sha256 "544f789c7dfefbc81b5e82cd74dcd2be3847ae8ce253d402852f19a82f25186b"
  license "Imlib2"

  bottle do
    sha256 arm64_sequoia:  "d6e559c4ee70c8d822c87db6278486da760e73bf34ef2d4be40a1152a989275f"
    sha256 arm64_sonoma:   "9085e6232c5f55a28549db1a2f5175ed3956307b894feee4c96e079136e0b0ad"
    sha256 arm64_ventura:  "4e51a7001b37bc1b970df359ad757b3c6c86d94a95723e07e53b92a586d9fc64"
    sha256 arm64_monterey: "854c0238df0cea22cefe702a71f4e411c0c68e1df76817430c75116ca75421f3"
    sha256 sonoma:         "858748fdfe4b3a886b09099f91452d0f051721d9dffd639827c42b5d63c59f40"
    sha256 ventura:        "428f45e532a9b3abbfd5fcdefab2881cf16838fef907f2de51245adb5e4036b7"
    sha256 monterey:       "2332ec7db084abef90fdd880cdd70d26e7d650d1bc04f6758af582d79b923f93"
    sha256 x86_64_linux:   "02135ffdab6c249729d5253a44c1a232c80be1f4464f8887524019404ed00b65"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-amd64=no",
                          "--without-heif",
                          "--without-id3",
                          "--without-j2k",
                          "--without-jxl",
                          "--without-ps",
                          "--without-svg",
                          "--without-webp"
    system "make", "install"
  end

  test do
    system bin/"imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
