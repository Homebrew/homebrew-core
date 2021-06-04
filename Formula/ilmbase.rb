class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with openexr.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_big_sur: "5a95c1ea57a08dde47723507b0406a408664e4170026a5a5771681f42ac3c6df"
    sha256 big_sur:       "846c944f66f265e002af5f3ba3f2a989fbbc8a175e394d5e597d56b50b480f74"
    sha256 catalina:      "bdb6dad0ee508d3bd86f50ced1eb15c0d0d25a1ffe1133659493f9cfccc41b52"
    sha256 mojave:        "7ab7edd363f935a6411b038adea08d1aaf0e8eba1168cdd58fda21182346fc4a"
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

  def caveats
    <<~EOS
      `ilmbase` has been replaced by `imath`. You may want to `brew uninstall ilmbase`
      or `brew unlink ilmbase` to prevent conflicts.
    EOS
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
