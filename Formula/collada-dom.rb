class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 3
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "6e849804d323a9fd1c923b53c6443b6ecf321944261edcf8753d0c0cd66e8b84"
    sha256 cellar: :any, arm64_big_sur:  "3195e13bd13dfe7c82b8ea21a071b23adec910be76c6d97cc32faf2f7ddfa360"
    sha256 cellar: :any, monterey:       "991f80ac768679b331ae54693c72f3ba02299e5d1ad880580e29e953c5a3e81c"
    sha256 cellar: :any, big_sur:        "3dbe95ca557849991af93070e1c207dc9ee6addc6c6926f8197edf7ac9471bbd"
    sha256 cellar: :any, catalina:       "64b2e314008a4abf5c18f53b8d29a34c83c49a1e6c869b7f709989af7dc91303"
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
