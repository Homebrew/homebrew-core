class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 6

  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "e7e430319ab49a85386803703632e216b24d3147815728e5a3264af3a85bcd9a" => :sierra
    sha256 "a4cc411b00d3339871dc5f4f10bdf8ad6e6175f1f16c72cb3ea5fc91985bb616" => :el_capitan
    sha256 "34fbfb1619248eb5cdb990f794048d58f6d2f1e6072fc9dfadbfc32714edb9b6" => :yosemite
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
