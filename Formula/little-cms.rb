class LittleCms < Formula
  desc "Version 1 of the Little CMS library"
  homepage "https://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/1.19/lcms-1.19.tar.gz"
  sha256 "80ae32cb9f568af4dc7ee4d3c05a4c31fc513fc3e31730fed0ce7378237273a9"
  license "MIT"
  revision 1

  livecheck do
    skip "1.x versions are no longer developed"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ffcd73342ab7d70a8a355578f62947ed40701d3fd2a443ff505235bbb9a26fc"
    sha256 cellar: :any,                 arm64_big_sur:  "e16ca9dc1d92be7f1aefb1496d713c4635aaa032dac246df26dd7e86ad1abd65"
    sha256 cellar: :any,                 monterey:       "03ba1b40b43757c686de1f5ad61b386fda288ab4f1acfee1e8aa773cb55fe00b"
    sha256 cellar: :any,                 big_sur:        "1936e2e42994578c57a209c4bcbca9f817af24ebe6f89ef6ab42d90b93e3bc85"
    sha256 cellar: :any,                 catalina:       "73cda76fd98e9466e570243f5190e68b45ffeeea2073185a51dd14dbde11a21a"
    sha256 cellar: :any,                 mojave:         "d04e4cc09f471260e6e86eb866743eb0205b3345bc9e687d85307cdbd1a1fa9a"
    sha256 cellar: :any,                 high_sierra:    "cead96af013b65c05e98c89890e66de1cdf864d1b6ed7da811f6618f2e551275"
    sha256 cellar: :any,                 sierra:         "227c16cbe117abeac7398265543c20b905396b214785e1a9dc48041f0f3ce128"
    sha256 cellar: :any,                 el_capitan:     "c1125a0074a82747ffc33ab79c617ea448b605ace47d6c5cf788f2d3a49d7c5d"
    sha256 cellar: :any,                 yosemite:       "bc02c8267bf616ef0dcfc27db97a849b0f79e8211164ea4a955482b964255a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c687f10094faebcec6573681241dc7f45e3f19ffcaab3ef2a56c987d13ba18a3"
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
