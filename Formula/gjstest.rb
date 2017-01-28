class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 8
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "6cee4a3edb5b13508716a740399cadf59c24e1f464f882a54e19da383c23d2bf" => :sierra
    sha256 "6f5969e3c6818d19438dd55e70000b648f14df44c9d215cb2373a21df3363b1f" => :el_capitan
    sha256 "5cce5d7d674dcf4537c60e5bb6326986e20b953521f6e5edf169cd39556e6a3d" => :yosemite
  end

  depends_on :macos => :mavericks

  depends_on "gflags"
  depends_on "glog"
  depends_on "libxml2"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "v8"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"sample_test.js").write <<-EOF
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOF

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end
