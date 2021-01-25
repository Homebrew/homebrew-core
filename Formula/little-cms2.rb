class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "https://www.littlecms.com/"
  # Ensure release is announced at https://www.littlecms.com/categories/releases/
  # (or https://www.littlecms.com/blog/)
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.11/lcms2-2.11.tar.gz"
  sha256 "dc49b9c8e4d7cdff376040571a722902b682a795bf92985a85b48854c270772e"
  license "MIT"
  version_scheme 1

  # The Little CMS website has been redesigned and there's no longer a
  # "Download" page we can check for releases. As of writing this, checking the
  # "Releases" blog posts seems to be our best option and we just have to hope
  # that the post URLs, headings, etc. maintain a consistent format.
  livecheck do
    url "https://www.littlecms.com/categories/releases/"
    regex(%r{href=.*lcms2[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "e6f70f21087ef1f0e1379446b5b5f460915d3a132763919feb245534ed9bc4af" => :big_sur
    sha256 "249a7b998b64074fa0978aa52cdbb9d11414734b2b5c2061ebc61159a9f98771" => :arm64_big_sur
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
