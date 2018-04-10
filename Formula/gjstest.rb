class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  revision 13
  head "https://github.com/google/gjstest.git"

  stable do
    url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
    sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"

    # Apply upstream patch for v8 6.5 compatibility
    patch do
      url "https://github.com/google/gjstest/commit/8218472140582e2efd1a9dfb2d7b969610a02d75.patch?full_index=1"
      sha256 "736a9ac4e963801730ac8d482ed4817ebc5c57d5395b7a05236b7841423218dd"
    end
  end

  bottle do
    sha256 "23787738847f2dfbe0c3d6943c846ec14530b8b1a79441b3af8d118adc5b3671" => :high_sierra
    sha256 "848873eb3f3b770f2e67ffe2747a91b0fcddabda910eb2764bcb1e1ce9060c38" => :sierra
    sha256 "c487833143ddbab1244ce53771436683e6fe294d258b41b344331c5311e288e9" => :el_capitan
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
