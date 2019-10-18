class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.11.tar.gz"
  sha256 "ea1f8b6bcb58dee19e2d8168ef4efd01e222c653eabbd3109aad57a870cc8c9b"
  revision 2
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "4a2e19a0839d0380ca489c12a75b01da11901b9763654ac0303985dd231d8773" => :catalina
    sha256 "bb14b782c2af2a0422f75e80031672850cda3773a36eec14b052a5595e504470" => :mojave
    sha256 "0cd96ff6e0946717110e360e8efa167a63bafc3f4b51a868da638c45861426e0" => :high_sierra
    sha256 "0c07189268c9dbe3060751957ff33a6c0c396aef103198c57565a74e440cab09" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
