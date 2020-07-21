class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.11/lcms2-2.11.tar.gz"
  sha256 "dc49b9c8e4d7cdff376040571a722902b682a795bf92985a85b48854c270772e"
  license "MIT"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "b0fe7486871b0fb0e34012f48bce09e96229e5e2985d64e7a0164c2847e41975" => :catalina
    sha256 "e05f0a487d2243411eeb9fd9909f875517d7b27feb3cb914117acd9c60b76fcc" => :mojave
    sha256 "928d1b8b8292a2d7950d0ef1381c70996bcde325f0124d7dcb68059090544dac" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
