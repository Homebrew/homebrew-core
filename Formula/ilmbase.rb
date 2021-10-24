class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.7.tar.gz"
  sha256 "36ecb2290cba6fc92b2ec9357f8dc0e364b4f9a90d727bf9a57c84760695272d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d7b2c18d6ce5020bca1367b97d6cc98592a68b61e26fe42dfed2f990f59469a"
    sha256 cellar: :any,                 arm64_big_sur:  "972c5920255115ab63cc84c699e9cd032d120bbb85095f8a4d1f2865326ceaa8"
    sha256 cellar: :any,                 monterey:       "c248dbaa4a43933316a046c32a616f1a2ac559f137fe3795e2c18ac323439870"
    sha256 cellar: :any,                 big_sur:        "71c8e6cedb938d2c5ec99fea9343805f293013b070ad561e2fa652194f84a59c"
    sha256 cellar: :any,                 catalina:       "e505a83ecb7ab3aee3f5cb38973612a559ec106a96d7142bc0f245556512a670"
    sha256 cellar: :any,                 mojave:         "a3416415f8a68fc12922080e36e24481833343d89a06aad74ad57034b2200eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de87ab59dcd306ea5dadae39afd1fa62304843e3af6cde221b197d9756005598"
  end

  keg_only "ilmbase conflicts with `openexr` and `imath`"

  # https://github.com/AcademySoftwareFoundation/openexr/pull/929
  deprecate! date: "2021-04-05", because: :unsupported

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
