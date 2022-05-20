class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 4
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8782a71f1737e6809e0bf8e03c1dbacd3822de5bb2b19857ca03c6df7d8a5c1a"
    sha256 cellar: :any,                 arm64_big_sur:  "0c81274c8d13c19d95d69fdad59ed8fd94e3860f90b0eb2ca83a45435b214769"
    sha256 cellar: :any,                 monterey:       "dba41e09a3ead21456f9d727eb6bede873098b7d0499629264900b618e7eace2"
    sha256 cellar: :any,                 big_sur:        "6ef9f48897bb6fe32ed7cc51666c35415e7d1c77a1e5d10701c64a69402cdd84"
    sha256 cellar: :any,                 catalina:       "9983a52d1c8b71c44f2bd435f4336a69c98aa1adf029b0fe72aebc6da23d10b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a23ff2a31d049557d533c50c1a30ab1e8c28d4ff28627e7ddb4ad08dcaeda8"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
