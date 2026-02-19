class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "https://www.ribbonsoft.com/en/what-is-dxflib"
  url "https://www.ribbonsoft.com/archives/dxflib/dxflib-3.26.4-src.tar.gz"
  sha256 "507db4954b50ac521cbb2086553bf06138dc89f55196a8ba22771959c760915f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ribbonsoft.com/en/dxflib-downloads"
    regex(/href=.*?dxflib[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3bbe74f4cb179ff9cd5df3e09b664f29033deb63211128b73bab5cf18c6b71a1"
    sha256 cellar: :any,                 arm64_sequoia:  "a4ba8424bf3cd50726d26445fa590fb069d6dff461324400938a3be82e98ef0c"
    sha256 cellar: :any,                 arm64_sonoma:   "b82a6721fde448b539b34656cbde8cdd0699373ca2ce134f7d7424d8cdd29c66"
    sha256 cellar: :any,                 arm64_ventura:  "6807f88414e5cf6c874dd7eebd579298ecc0e99babb950a9a454cc9a55541071"
    sha256 cellar: :any,                 arm64_monterey: "7394d8e91ad3daefb69baae95372e86243fa69252aaaff0671aae88c5385b8be"
    sha256 cellar: :any,                 arm64_big_sur:  "38f73afafa3258b4d298f173064099dac105ab5bc162eae367d76fe326f5fbb8"
    sha256 cellar: :any,                 sonoma:         "7428941eb92a81ca91bba17c724a82392ad210bd545eba3566d89be9dc028d59"
    sha256 cellar: :any,                 ventura:        "996710f91cf68315863c2d6b99666295ef2ef91de2c1cda1a2126154547ce89f"
    sha256 cellar: :any,                 monterey:       "47ebef21d6211ac7b080a8f1ed23dfb154febdf8dfd1a157b14e3c5dccea2812"
    sha256 cellar: :any,                 big_sur:        "86c60b0cc3b353b3652d6bb819c41fcec1cebc6c2f1f7ae435696bbae757a16f"
    sha256 cellar: :any,                 catalina:       "8bfd7c24979cf19191ff911bae9173666f84cf3b5995f3e16672041a9720220f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c3d6128db7bb1a09a4e280074706cece0535a47ec8db471d4e7ad941dc7e2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e71a7e5920a5c7d7029edcf188bebf88aea640021d459ba1e2c0fa7266970c3a"
  end

  depends_on "qtbase" => :build

  # Sample DXF file made available under GNU LGPL license.
  # See https://people.math.sc.edu/Burkardt/data/dxf/dxf.html.
  resource "testfile" do
    url "https://people.math.sc.edu/Burkardt/data/dxf/cube.dxf"
    sha256 "e5744edaa77d1612dec44d1a47adad4aad3d402dbf53ea2aff5a57c34ae9bafa"
  end

  def install
    # For libdxflib.a
    system "qmake", "dxflib.pro"
    system "make"

    # Build shared library
    inreplace "dxflib.pro", "CONFIG += staticlib", "CONFIG += shared"
    system "qmake", "dxflib.pro"
    system "make"

    (include/"dxflib").install Dir["src/*"]
    lib.install Dir["*.a", shared_library("*")]
  end

  test do
    resource("testfile").stage testpath

    (testpath/"test.cpp").write <<~CPP
      #include <dxflib/dl_dxf.h>
      #include <dxflib/dl_creationadapter.h>

      using namespace std;

      class MyDxfFilter : public DL_CreationAdapter {
        virtual void addLine(const DL_LineData& d);
      };

      void MyDxfFilter::addLine(const DL_LineData& d) {
        cout << d.x1 << "/" << d.y1 << " "
             << d.x2 << "/" << d.y2 << endl;
      }

      int main() {
        MyDxfFilter f;
        DL_Dxf* dxf = new DL_Dxf();
        dxf->test();
        if (!dxf->in("cube.dxf", &f)) return 1;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{include}/dxflib", "-L#{lib}", "-ldxflib"
    output = shell_output("./test")
    assert_match "1 buf1: '  10", output
    assert_match "2 buf1: '10'", output
    assert_match "-0.5/-0.5 0.5/-0.5", output.split("\n")[16]
  end
end
