class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v2.5.8.tar.gz"
  sha256 "db261a7fcc046ec6634e4c5696a2fc2ce8b55f50aac6abe034308f54c8495f55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "762d98fe349986d21c46039a29aec6116a425b2ec2a9f249e743d11e183479bd"
    sha256 cellar: :any,                 arm64_ventura:  "9dc12fdb45d5e21b5424a1096771b83cca1de04cf3914eb2c5193bb4724a8d4a"
    sha256 cellar: :any,                 arm64_monterey: "398bd979380275b9c0db5577df3a5d334e1d9d94022479f8677b5871998231cd"
    sha256 cellar: :any,                 arm64_big_sur:  "d616fac56b2bb43a3fdbfcd7f02cd25afae16e90b004fead3f45e69100bc00f5"
    sha256 cellar: :any,                 sonoma:         "37add28b486d2e6e5ac8a6a8b2fd9ece269316800d1c0fae1375a83035a8af85"
    sha256 cellar: :any,                 ventura:        "38dcd09c2d51fd78e2f9fefcd2fe007186a2e43cd586e6e179d434fdb8c2c1f1"
    sha256 cellar: :any,                 monterey:       "d7be04686035d70c27ce4b4bba6d03cb1c0c2ea9bd6b39b889d1d0f5ef2744a3"
    sha256 cellar: :any,                 big_sur:        "bdf07479c3091736bacc2084f4559453278303432233e911c5f68e3861b56fab"
    sha256 cellar: :any,                 catalina:       "604258f3462b62c34dd27ea064097da000e558e4db3d5cc68746aa8a7ab69e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12083e35dab46f88283fc50b6cb1b93c595db07102814e0effef211f669a968"
  end

  keg_only "ilmbase conflicts with `openexr` and `imath`"

  # https://github.com/AcademySoftwareFoundation/openexr/pull/929
  disable! date: "2024-02-07", because: :unsupported

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
