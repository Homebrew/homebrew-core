class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.8.5.tar.gz"
  sha256 "7895fe0cb7b18d9e40d0353df2ec964aed4e1bb7fa7e1ea9a1e00858d3a89ce9"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "61a9d5421540dac2e84927326efdbb787a03c69e3282e8a429334f38e78204b5" => :sierra
    sha256 "c1bf863c406fbf2282ec726999be8c407315cd41f29601ec5f5dd77210a813e9" => :el_capitan
    sha256 "f9346c3872acd0fcebb5b5ff5a6a6bcf5d8ccfc6bbfa23731a3d3731a20b50ff" => :yosemite
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
