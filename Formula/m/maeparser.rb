class Maeparser < Formula
  desc "Maestro file parser"
  homepage "https://github.com/schrodinger/maeparser"
  url "https://github.com/schrodinger/maeparser/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "78e7571a779ea4952e752ecef57c62fb26463947e29ef7f4b31b11988d88ca07"
  license "MIT"
  revision 2
  head "https://github.com/schrodinger/maeparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ab72f0ad5c5537a43ca12641ea09bb11aaadbe4ac1e4a165dc1c4c9f083550f"
    sha256 cellar: :any,                 arm64_sequoia: "a91901b461024886fc5a21c50a04ec1feb18632037747775d21bf2a6f2d078e5"
    sha256 cellar: :any,                 arm64_sonoma:  "0395ee6964880665d0ed6ea81c3c74fbc865f7f0d1cada62c5fc710c89ea9033"
    sha256 cellar: :any,                 sonoma:        "dd48a5685b50947fdc18cc1d553911a988ac672094741c5f959d41d43e367bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adad547947d2aef9ae2c1824bdafd8b1be4e65149b9a8729823ff68cb6725640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74f789cea08e79f32d0b2f8dfe2c5f718bd8e5797e4c8960b94cbdb08a153bf5"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMAEPARSER_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/MainTestSuite.cpp", "test/UsageDemo.cpp", "test/test2.maegz"
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cxx, "-std=c++11", "MainTestSuite.cpp", "UsageDemo.cpp", "-o", "test",
                    "-DTEST_SAMPLES_PATH=\"#{testpath}\"", "-DBOOST_ALL_DYN_LINK",
                    "-I#{include}/maeparser", "-L#{lib}", "-lmaeparser",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_filesystem", "-lboost_unit_test_framework"
    system "./test"
  end
end
