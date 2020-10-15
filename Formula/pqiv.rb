class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.11.tar.gz"
  sha256 "ea1f8b6bcb58dee19e2d8168ef4efd01e222c653eabbd3109aad57a870cc8c9b"
  license "GPL-3.0"
  revision 4
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "406bf15556cbc6f3d23f20784f7f8de5c7338675e48ce7237fb9759ad348ebd5" => :catalina
    sha256 "c7f56c5b90ce529d8da4e09f7a8d502c49fb3bf15ca7a7a3fe824001f0a4236e" => :mojave
    sha256 "b2b084b475294c9ad63da9c073aceaaaaa26d6f1bb6f8a0cd37898b670a9703d" => :high_sierra
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
