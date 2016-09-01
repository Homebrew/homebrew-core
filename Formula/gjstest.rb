class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 4

  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "df66465896fbfb8ed54ba0a8a55d2babafa98e4d5c89b619bbd6fa5839dd4627" => :el_capitan
    sha256 "9fff03cc88eb9004d79db5c5e38c5b10f13fb8d575aa1cd6e6e9ec4d0e2ed5b1" => :yosemite
    sha256 "2cc239dfec6a8cf57203efbb280e37adfff292d4317391a8d78280d45cbeea99" => :mavericks
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
