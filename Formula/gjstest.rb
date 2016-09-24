class Gjstest < Formula
  desc "Fast javascript unit testing framework that runs on the V8 engine."
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 6

  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "6b1e94b5722ca8d032e5a847d85ac03ddc86fb1ac67a1daaba79fdec82d22432" => :el_capitan
    sha256 "37bfb50ab37de1d41771b4ef71a1b9a1de7839dfca5e71185ec5daa9c053e837" => :yosemite
    sha256 "b4d5d85ff25134f8eb2c0d545915abefebef5c364e59e696b939541581472481" => :mavericks
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
