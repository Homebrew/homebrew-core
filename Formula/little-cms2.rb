class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.10/lcms2-2.10.tar.gz"
  sha256 "50d411fd494c7c6973866e08c05dea83245d7e23a0db6237a9d00f88b2e0f346"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "0a03a16dbbb3628e5ab6ce8a99c302222aa062cb412d94939a59ec9ff15af843" => :catalina
    sha256 "cd6e44776acd687870dcde0a5d0e180f0023c9ea4d1cf0010ff2084a286c0153" => :mojave
    sha256 "7d397c359911bea902ae0bb5463a8bad2f5cf1ecd08fddcdceadb26a7474b0a9" => :high_sierra
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
