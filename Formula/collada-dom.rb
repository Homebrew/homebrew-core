class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 5
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3ae338e6a182aa4ef5162f236dd1eaaae5af7a6bda9b2371b55e90ad1b14b775"
    sha256 cellar: :any,                 arm64_monterey: "27cb70edcab5aabbc09e3e49b4d4096b7940437f5ee70ccf7cbc37dcc27428c0"
    sha256 cellar: :any,                 arm64_big_sur:  "56e8736323a26b1aaea44616640bfb571e149365f51768ffbd29b1dd10f5a7dd"
    sha256 cellar: :any,                 ventura:        "70573c30ce81d80a2adc1fadeaec07f50346f1e1091b8bdbffd426a722f98b88"
    sha256 cellar: :any,                 monterey:       "a445d8dab60d0b4558650632ad26d5bcc2472679f775222a17b8824cb50d4d3d"
    sha256 cellar: :any,                 big_sur:        "33265c5810adff137167e86a0db1bb89fbde13c8809f74e857acb173a6a7adf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7b2b02132feee5ee2de9b5787a7fc224d71e1cb5e8e5b727cbe5fc02cf815f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "uriparser"

  uses_from_macos "libxml2"

  def install
    # Remove bundled libraries to avoid fallback
    (buildpath/"dom/external-libs").rmtree

    ENV.cxx11 if OS.linux? # due to `icu4c` dependency in `libxml2`
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <dae.h>
      #include <dae/daeDom.h>

      using namespace std;

      int main()
      {
        cout << GetCOLLADA_VERSION() << endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/collada-dom2.5",
                    "-L#{lib}", "-lcollada-dom2.5-dp", "-o", "test"

    # This is the DAE file version, not the package version
    assert_equal "1.5.0", shell_output("./test").chomp
  end
end
