class Gqview < Formula
  desc "Image browser"
  homepage "http://gqview.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gqview/gqview/2.0.4/gqview-2.0.4.tar.gz"
  sha256 "97e3b7ce5f17a315c56d6eefd7b3a60b40cc3d18858ca194c7e7262acce383cb"
  revision 1

  bottle do
    sha256 "ef7dbffe9de32bc2aab41756951fc374058f2317a9fea19e8cacb6a0fc3c2bac" => :sierra
    sha256 "79fd96b1ea513216f2db420d2d0275d9a14ed99bda9a4a83d0f5587eb8f1d298" => :el_capitan
    sha256 "e6662b9adbe591c01f599293ac65d40755cf097df40a914c568a4ef961edb586" => :yosemite
    sha256 "05ae1074ccd46e283e40a9455d43fae4b124726272ca9bdbfc941b05517da500" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/gqview", "--version"
  end
end
