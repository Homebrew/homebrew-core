class Exiftran < Formula
  desc "Transform digital camera jpegs and their EXIF data"
  homepage "https://www.kraxel.org/blog/linux/fbida/"
  url "https://www.kraxel.org/releases/fbida/fbida-2.14.tar.gz"
  sha256 "95b7c01556cb6ef9819f358b314ddfeb8a4cbe862b521a3ed62f03d163154438"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://www.kraxel.org/releases/fbida/"
    regex(/href=.*?fbida[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "501742a3d0ffef91bd7551c924f5073b0c001c8c8b7618e2a7db7d9ffdfdfd82"
    sha256 cellar: :any,                 arm64_monterey: "cdbebc6e9ea054a40e6c9d9ecd8265d62dfff2b9da689748ff8a87fb8defb9b1"
    sha256 cellar: :any,                 arm64_big_sur:  "e16c172257b1786e0d0186336c8c35b16efab57c919598df0bc920999c2905f1"
    sha256 cellar: :any,                 ventura:        "d425c26a0bcc36d4427e9612f963755421676559ea3b5519294bfeadc7ac6f6d"
    sha256 cellar: :any,                 monterey:       "af336311bf9e98d1d5569496463b9b0a7c4efc2e5aedf3f6778e71cf34e45349"
    sha256 cellar: :any,                 big_sur:        "b8b303e6e7ae7ef407882e37bf67865253cce06924c4efe18b1a817dd1178ec4"
    sha256 cellar: :any,                 catalina:       "3585d1c19e27eb8510476b8c89b2a97546071c817ab6dc5e1ec77a0f36bb4e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068ea42ed133bda1659d3de1d61185616377568d8284bab223dcb0e023b2aba9"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "pixman"

  on_linux do
    depends_on "cairo"
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "ghostscript"
    depends_on "libdrm"
    depends_on "libepoxy"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "openmotif"
    depends_on "poppler"
    depends_on "webp"
  end

  # Fix build on Darwin
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/185c281/exiftran/fix-build.diff"
    sha256 "017268a3195fb52df08ed75827fa40e8179aff0d9e54c926b0ace5f8e60702bf"
  end

  def install
    system "make"
    system "make", "prefix=#{prefix}", "RESDIR=#{share}", "install"
  end

  test do
    system "#{bin}/exiftran", "-9", "-o", "out.jpg", test_fixtures("test.jpg")
  end
end
