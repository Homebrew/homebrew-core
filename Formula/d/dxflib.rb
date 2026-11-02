class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "https://www.ribbonsoft.com/en/what-is-dxflib"
  # Use Debian source as the upstream removed the source
  url "https://deb.debian.org/debian/pool/main/d/dxflib/dxflib_3.26.4.orig.tar.gz"
  sha256 "e7208c9b67f5bc6727a0e3adf2162d8e67d80e0244dcda167fb7535556d944a1"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "c67b371ff4e84bea6a59ec51d213c56148f5e92b31f4b90b5e411ffd8160481f"
    sha256 cellar: :any, arm64_tahoe:       "c67b371ff4e84bea6a59ec51d213c56148f5e92b31f4b90b5e411ffd8160481f"
    sha256 cellar: :any, arm64_sequoia:     "4d62711de529928930dc1bbd6dc10bfb513ddefe875632c8540924a8a842a388"
    sha256 cellar: :any, arm64_linux:       "ab93e12ffc9fe907159d34bb89e5414631e5122ee37b3dce441e22636d520664"
    sha256 cellar: :any, x86_64_linux:      "40bd9ae89bd32661e2903e64e0b800ca4b5b887585804b1eaede390cef271abe"
  end

  # Source and homepage URLs redirect to `https://www.qcad.org/en/` which
  # has no mention of `dxflib`
  deprecate! date: "2026-10-21", because: :repo_removed
  disable! date: "2027-10-21", because: :repo_removed

  depends_on "qtbase" => :build

  # Sample DXF file made available under GNU LGPL license.
  # See https://people.math.sc.edu/Burkardt/data/dxf/dxf.html.
  resource "testfile", :test do
    url "https://people.math.sc.edu/Burkardt/data/dxf/cube.dxf"
    sha256 "e5744edaa77d1612dec44d1a47adad4aad3d402dbf53ea2aff5a57c34ae9bafa"
  end

  deny_network_access!

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
