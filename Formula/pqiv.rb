class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.9.tar.gz"
  sha256 "e57298ae7123bd6b01b751f6ef2d7a7853e731a3271b50095683442a406da99c"
  revision 3
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "2d4451841b7b0657c8bebbaba8c15ef5acdb928c09c9b6b395f7a66fc4e8e159" => :high_sierra
    sha256 "1e32bc814647929f99edfa0c254a759325e089557f34b9dd6b1db9e46a376614" => :sierra
    sha256 "4f8b5d2b5ffe2f2b806f8ae922ae821ecc5bd8aa663a2f7632d209133a0946aa" => :el_capitan
    sha256 "b8adaeeed479e3ef65d18e047bafd8d47171de0f4afd23318fb9dd402ab0a4ea" => :yosemite
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
