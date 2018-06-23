class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 13
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "1b61074dc9a8e50b39794cb984cf3c9de841a83f6f31c59b614eb751d545f0ab" => :high_sierra
    sha256 "dbe651fdbf5d55fd4813a7ec46bb855651d6866078931e8da304a7c68e5fe270" => :sierra
    sha256 "0ca5e3fe6dcc0d49844462285f8db439c4471d448e17e0a1f948147a21ae2064" => :el_capitan
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
    (testpath/"sample_test.js").write <<~EOS
      function SampleTest() {
      }
      registerTestSuite(SampleTest);

      addTest(SampleTest, function twoPlusTwoEqualsFour() {
        expectEq(4, 2+2);
      });
    EOS

    system "#{bin}/gjstest", "--js_files", "#{testpath}/sample_test.js"
  end
end
