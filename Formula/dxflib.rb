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

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, big_sur:      "ffdf278bbcd52a31f20e536cec99fb30c5bf94d7f353b3c4b4f943666717da11"
    sha256 cellar: :any_skip_relocation, catalina:     "70b4e8b65b8a1090eb19080c1ec7675ec58aaef4c573ac2af89f2fe985e23d7e"
    sha256 cellar: :any_skip_relocation, mojave:       "1b9e667aa5bb30e050f41370afbbfaa91a563ab015a4ab4930c7dbb99fccc956"
    sha256 cellar: :any_skip_relocation, high_sierra:  "fb790fe1b9357907e77f50650ed0d696e855c311320d726472ac511297994573"
    sha256 cellar: :any_skip_relocation, sierra:       "db45aa2b00f82b996370eaf1321e0cce79fc3868c42a9524e10adce478139bc2"
    sha256 cellar: :any_skip_relocation, el_capitan:   "aff6c3f5e5bca552c5962e8ef5c43d1dd5fb0630d091e206a164e99ed8b70637"
    sha256 cellar: :any_skip_relocation, yosemite:     "e883aa60c9baab1198671db178c0723e4331ed9fb65ad4d87ba72ca921d7d0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6ab01712961c1a8561d2fc7926397b75169bb67ef89ebfadf4ee7ead4581d4c3"
  end

  depends_on "qt" => :build

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

    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{include}/dxflib", "-L#{lib}", "-ldxflib"
    output = shell_output("./test")
    assert_match "1 buf1: '  10", output
    assert_match "2 buf1: '10'", output
    assert_match "-0.5/-0.5 0.5/-0.5", output.split("\n")[16]
  end
end
