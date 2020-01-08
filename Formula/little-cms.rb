class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"
  revision 1

  bottle do
    cellar :any
    sha256 "73cda76fd98e9466e570243f5190e68b45ffeeea2073185a51dd14dbde11a21a" => :catalina
    sha256 "d04e4cc09f471260e6e86eb866743eb0205b3345bc9e687d85307cdbd1a1fa9a" => :mojave
    sha256 "cead96af013b65c05e98c89890e66de1cdf864d1b6ed7da811f6618f2e551275" => :high_sierra
    sha256 "227c16cbe117abeac7398265543c20b905396b214785e1a9dc48041f0f3ce128" => :sierra
    sha256 "c1125a0074a82747ffc33ab79c617ea448b605ace47d6c5cf788f2d3a49d7c5d" => :el_capitan
    sha256 "bc02c8267bf616ef0dcfc27db97a849b0f79e8211164ea4a955482b964255a7e" => :yosemite
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --disable-debug --prefix=#{prefix}]
    system "./configure", *args

    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/jpegicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
