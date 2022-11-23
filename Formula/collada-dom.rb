class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 4
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c920a17cba52a9eddfcf9951004af4f929ac75c332aea326d6526302b26a7392"
    sha256 cellar: :any,                 arm64_monterey: "3f4c94c87fcf91e70742ee59d9beaac2795f0338732d5416a68e498d58c4067d"
    sha256 cellar: :any,                 arm64_big_sur:  "0fd24a0542b44e9718527d769a8f3b2229ee2f3f9e0c114472d0d28f9499edc7"
    sha256 cellar: :any,                 ventura:        "e44ce87f14897e0656a82496c88935dee68e96e509a58c4f47ea03aa74ab8284"
    sha256 cellar: :any,                 monterey:       "70bca431ec07f8e203c0fb60621527a6df11a122871c02af2e3b34cb615542bb"
    sha256 cellar: :any,                 big_sur:        "45fe76243a5bfb058c5e5e618d7fa974177097c52ffedcaa53e2b19180634221"
    sha256 cellar: :any,                 catalina:       "8cfbaf5caa2d489b860348d49596907fb137048241f64645a60d5156f4378ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01048c13f1eb1ac249b40ff691c712724d0cbcaabfbc0d11eead0db21f15f5fa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "minizip"
  depends_on "pcre"

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
