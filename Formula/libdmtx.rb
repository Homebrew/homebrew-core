class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.io"
  url "https://github.com/dmtx/libdmtx/archive/v0.7.5.tar.gz"
  sha256 "be0c5275695a732a5f434ded1fcc232aa63b1a6015c00044fe87f3a689b75f2e"

  bottle do
    cellar :any
    sha256 "4631cea68d83f274390ff023591256a92fb108b685c0528448a43a48d583c09b" => :mojave
    sha256 "eb892feb7d29f9291a0edc2be6c34b4584614103d4af9d1c62eb54370decd8e1" => :high_sierra
    sha256 "c93913cd5aff29278c538957fd6890d990f760abaff1b14cea6f6f171194b706" => :sierra
    sha256 "ebcd82bf4d9da2a71bd066722ce6750d6cf064b1c8f477ba9aca47987acd330c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
