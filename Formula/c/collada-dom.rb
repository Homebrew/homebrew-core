class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 6
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9235146a1aa84c38133fbcd3677737d92d5243877899dff9e02728e2eadda939"
    sha256 cellar: :any,                 arm64_ventura:  "4d09b42ccb15cc1ea1387eca3ea1e2c16fecaddc33a482fab5a4030d67b73ac7"
    sha256 cellar: :any,                 arm64_monterey: "8e6113955d8a7190e773d71851152d9957a75e2d3bf1153ec056af0190cde261"
    sha256 cellar: :any,                 arm64_big_sur:  "a392f8f5c3055ba99b094be9e57d791c3284276c10fbebc9c0e73d56bb33edfa"
    sha256 cellar: :any,                 sonoma:         "ea24f8c02813877d90090f00f161a8fbb05e65944e2162d6ff8ed1749850dc2d"
    sha256 cellar: :any,                 ventura:        "ac8dcee133cf2923bc6e508974ae9950944d6f9bf22a821cb5447ad8cd7c800e"
    sha256 cellar: :any,                 monterey:       "848905d73d077fa02c7ca62bea14bc104febaf0a64e765e9fa19235c97114e3b"
    sha256 cellar: :any,                 big_sur:        "1d537d126e8d473e20015670d0e218480c416d8592027ffd90e9714ab693c7dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86dc502cb34113b167e7fbb9a63837a373bd76cff2fc007c3c00b63e89f78819"
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
