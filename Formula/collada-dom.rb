class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  url "https://github.com/rdiankov/collada-dom/archive/v2.5.0.tar.gz"
  sha256 "3be672407a7aef60b64ce4b39704b32816b0b28f61ebffd4fbd02c8012901e0d"
  revision 1
  head "https://github.com/rdiankov/collada-dom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6baf8c9373cc9694ee34a651bcc5e7f334853969394d3d4b6b64d20688cf396a"
    sha256 cellar: :any,                 arm64_big_sur:  "d4c611de9f56ddadaf4e34fdea1049c02289fc81bd0bd9c6e6665f7f15c0f4cb"
    sha256 cellar: :any,                 monterey:       "764bd5de44b51b088e61df10fd3b8f66581b31ec37821810c6e24d9dd2bc4e32"
    sha256 cellar: :any,                 big_sur:        "b0987e22d6e0eb6a4b5d5c2413fd629204d1b32c13dd4798bca499446ff89391"
    sha256 cellar: :any,                 catalina:       "7f2ca06cafbed79ee7df9d03f7842a6bdee997f5d77ed8421b528f79fbe75dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e38b4a56ab6e5192f8f8d287fb33f0810c3a09fc1bbd32a490bc1486484594c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "pcre"
  uses_from_macos "libxml2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
