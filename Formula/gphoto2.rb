class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.14/gphoto2-2.5.14.tar.bz2"
  sha256 "9302d02fb472d4936988382b7277ccdc4edaf7ede56c490278912ffd0627699c"
  revision 1

  bottle do
    cellar :any
    sha256 "9a78be8163e8401c98fb02c9c1516d8417a275d0781a5b70e0acfcd6644e1612" => :sierra
    sha256 "89df497a74a4ce65994afd0d580484ef9cebba432cf60f3ec26f42a6c7d3528b" => :el_capitan
    sha256 "f4c828281de45a92b741a83be0f086da753396f787bf9167f1e5c7a6ae36d5af" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
