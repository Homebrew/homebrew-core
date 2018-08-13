class Gjstest < Formula
  desc "Fast JavaScript unit testing framework that runs on the V8 engine"
  homepage "https://github.com/google/gjstest"
  revision 14
  head "https://github.com/google/gjstest.git"

  stable do
    url "https://github.com/google/gjstest/archive/v1.0.2.tar.gz"
    sha256 "7bf0de1c4b880b771a733c9a5ce07c71b93f073e6acda09bec7e400c91c2057c"

    # Patches for compatability with more recent v8 versions
    patch do
      url "https://github.com/google/gjstest/commit/141f35d1fcb5c5fb0dc13421d74555255d98bed8.patch?full_index=1"
      sha256 "66208476d389295f8913513f893626891cdd562e205ec6616f90b3dc5af88d5a"
    end

    patch do
      url "https://github.com/google/gjstest/commit/b4cacaac8505f84e2341a39cffc047474d57b6a1.patch?full_index=1"
      sha256 "598d15f600ecd09392f014822a0756904f7ba825ba92de1ca107092513a93a0e"
    end

    patch do
      url "https://github.com/google/gjstest/commit/8218472140582e2efd1a9dfb2d7b969610a02d75.patch?full_index=1"
      sha256 "736a9ac4e963801730ac8d482ed4817ebc5c57d5395b7a05236b7841423218dd"
    end
  end

  bottle do
    sha256 "8b1152102634720119529ce4aab3822e1d94b3d131d8c3140df85af7086ff708" => :high_sierra
    sha256 "0d388431981f66d048e7fa4acad173d8afe4778e80483ebb8257d804b18c5a4e" => :sierra
    sha256 "0f0e4651730acdd762fced659605887a1c42d3846cc5e17c2e29a39b0e8f1074" => :el_capitan
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
