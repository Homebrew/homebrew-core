class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 9
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "4046f6b37a20d4d74ec0ec0f19b6dd5caaefde23cb96c4b5c1774088809fab7f" => :sierra
    sha256 "26c47f55000408255ea0d88fd436aa4862b6ee904c9c7d28a40ecb497f107a6e" => :el_capitan
    sha256 "1fb31a99306bef7e774445562a6c1585bde40d3136297c219135fb704feda291" => :yosemite
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
