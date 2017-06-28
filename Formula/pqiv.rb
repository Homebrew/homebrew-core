class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.9.tar.gz"
  sha256 "e57298ae7123bd6b01b751f6ef2d7a7853e731a3271b50095683442a406da99c"
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "0de9bc7c1b3f57220b22b181f619534cddb90b2569d2d29a5da798473bb84a5f" => :sierra
    sha256 "031bfb0ab1ac2320e4f7fa4ce7027cfab9cd00fca5c050ee8b4e9c77547d898c" => :el_capitan
    sha256 "e9d35506895d59fae456e97d824fd15be02dc88f7ee18f2541aa230382bdcba9" => :yosemite
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
