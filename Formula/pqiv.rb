class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.10.4.tar.gz"
  sha256 "58ddd18748e0b597aa126b7715f54f10b4ef54e7cd02cf64f7b83a23a6f5a14b"
  revision 4
  head "https://github.com/phillipberndt/pqiv.git"

  bottle do
    cellar :any
    sha256 "074b57fbff1b97003d7fd8260786bcd9c30b9e5f1dea50ece177489829937464" => :mojave
    sha256 "b40535852101a4c266a1acc2f4190be4ff616d1f0f75b98df8c2cabaeb350083" => :high_sierra
    sha256 "892aaf9f2be7541351812608329b3e6d2327138b0548eddb97bd918d34dea88e" => :sierra
    sha256 "6bb669ebf3359287d1120919ee8fb57a210adaede2d178d939495704081b92b0" => :el_capitan
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
