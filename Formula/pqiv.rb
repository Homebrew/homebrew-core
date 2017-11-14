class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.tar.gz"
  sha256 "d612cf1fc7d03596b24eadbe45ba4422ad5cf243d7157d122ca7dc309feaacb6"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "02bb55f6a47cf3e4260cf5627474fd094e32e3c4f973fee83ef85c6b1e9507ea" => :high_sierra
    sha256 "f7d7e7a6734500be3aa6da75eae659c7d76f3712f38b47be530ddaba1f8ffe64" => :sierra
    sha256 "2e472275da8bb37ab3de82284590721ee6614f9e64df8acd70f007805b944492" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "webp" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
