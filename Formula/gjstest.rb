class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
  sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"
  revision 11
  head "https://github.com/google/gjstest.git"

  bottle do
    sha256 "8d83d3c972829ac9a735815de344e2b6c9d94d980af7a85d4c7b3ff791f5347e" => :high_sierra
    sha256 "4262b8706aeb9faac11ed87365a452d5996f109dc818a35877965d7e1d72107d" => :sierra
    sha256 "3080f1cf83eb1f0fe616c84db85c852d990712b2a5165ddc5617e6761e071f2c" => :el_capitan
    sha256 "f83395858229abff30841225b6f81ea5a49eb2781ec42395867c72b46561cd56" => :yosemite
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
