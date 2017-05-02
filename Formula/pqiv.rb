class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.8.5.tar.gz"
  sha256 "7895fe0cb7b18d9e40d0353df2ec964aed4e1bb7fa7e1ea9a1e00858d3a89ce9"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "92b10126ae4021df2a90a36f3e21e0edb8a2a214db7d3b2e2600f5cdf09e77ec" => :sierra
    sha256 "cc05be27301c74765b93dd14076152092f3db758f1f26e1e2ee1a9a3f7362e39" => :el_capitan
    sha256 "64aab0ed33b8ebcaa7e89f2e7a5be94bb8514bd3f57d5f2ae027a562c62e65ee" => :yosemite
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
