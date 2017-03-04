class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.8.3.tar.gz"
  sha256 "b90c45d829eb180459dcfbf1420b8feb670dc9bb542fe307adbc4ff201445bbd"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "03483031c2cea834dbc850d2bc2caa6ce66b5b2d573f8a484774a14f39f53d15" => :sierra
    sha256 "e87993a6f12f5e40552f768bcf0f1052f135e652f99d7e61ee81bb2c4a4a15b2" => :el_capitan
    sha256 "99ce6c61c79284d39f861f766e40960f46b59f6b3ba29364aad3f16d9072951c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "libspectre" => :recommended
  depends_on "poppler" => :recommended
  depends_on "imagemagick" => :recommended
  depends_on "libarchive" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # pqiv does not work at all unless a display is present
    # (it just outputs an GTK error message)
    system "#{bin}/pqiv 2>&1 | grep -qi gtk"
  end
end
