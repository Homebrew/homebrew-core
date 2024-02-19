class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 8
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7d2f474db9960b48d1703adcc774a388d532c64255df86536b2d46e503cd7b8a"
    sha256 cellar: :any,                 arm64_ventura:  "77a24357dafdbf988e8c0551a711d25779f40921869ca1d92c5d7487f0ee93f6"
    sha256 cellar: :any,                 arm64_monterey: "181e093344078c8eed0f02a90cf33bffce6f1f23572fb3e81b4fd026e9c1c349"
    sha256 cellar: :any,                 sonoma:         "ffead388a79f7436590d344693cceb7d19eefcc9900360a44978ef740bfd42f5"
    sha256 cellar: :any,                 ventura:        "2f1c39e6d25c138cf3eea893d5828be969e4eb025ae3d9ee1d6e1163934c7111"
    sha256 cellar: :any,                 monterey:       "b56c5b6f38708e3d85d16456e5bbadbb32781b5c768e514456a0cec34078e296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8917630ae6e86a00b6c4340fd9e23962991d3c2b83e0af13f86f142a0f9b8a"
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
