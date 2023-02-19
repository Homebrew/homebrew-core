class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 5
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61af8e1cb68c831b2f0e05be428891369cd618a11fa5f599b64fcb7968da6cb5"
    sha256 cellar: :any,                 arm64_monterey: "a0742c5ac952ccef542876da61ded9131131b24459055f10c80054f1a305450f"
    sha256 cellar: :any,                 arm64_big_sur:  "b1ddb37ba6194106a32824a45dbf2e4d241b884ce7baca2addd466c08fad015a"
    sha256 cellar: :any,                 ventura:        "1c8c662ab73e9d52f11e2d68ec1dd79fa81fe7106e5d5cc8439459c06943235a"
    sha256 cellar: :any,                 monterey:       "3706f35b027bb23dc1e3ec4ead6af0f2c838a2c1a1b5c7afd756896d8868b30a"
    sha256 cellar: :any,                 big_sur:        "73b7eb7b3cb1396c014dc5985ea1ab2a8b43bb598dec4cd2b21e1ef33f7dc91e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afba4b3a5cd9a4179fcd80ea26097854818f5b1c830b742658365b4ea25c3e87"
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
