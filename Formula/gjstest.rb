class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 11
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "13143c8ff9f8c29655027f551edf64ec012998ecb717c5c4afd828093ac052c2" => :high_sierra
    sha256 "a96ab9bbfc38f4976ab672202a08fb663e6e88d48d646ff8cf2399e4e75c5912" => :sierra
    sha256 "b065d4e86f6d0acce5d291f6e99fd41af878267cf677d24b9f85248db3ddd068" => :el_capitan
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
