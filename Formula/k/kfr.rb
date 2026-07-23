class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/7.0.1.tar.gz"
  sha256 "42b36126f2af8719eff6f26e87e9f155816bc3bb110376e4747ba5de536c2cce"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86b96b05477af3f3661276b223983fadd610b7e471407430f7cc1cf2e314a8eb"
    sha256 cellar: :any,                 arm64_sequoia: "6949146a34c9d4a8b7b5103627af381974e099ac00db4585e4868352db3f112a"
    sha256 cellar: :any,                 arm64_sonoma:  "10b71e67e14e341e2929939d3e0ad45f41bdaf04ae6f8821eca18be2ec6cffd7"
    sha256 cellar: :any,                 sonoma:        "1fdb1f8bef584d04821453d680e647e7391d33c5a99508f2c7a1c166dc4a8a54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02b2233a450327c2fe7981153fa72dd2ae1f06ab752d805f66343753b27f66ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7a12b26f03bbc10216e6b018499cf826967814c5067df3631928b84bce4eb5"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  on_arm do
    # FIXME: `uses_from_macos` is not allowed in `on_arm` block
    on_linux do
      depends_on "llvm"
    end

    fails_with :gcc do
      cause "ARM builds require Clang compiler"
    end
  end

  def install
    args = ["-DKFR_USE_BOOST=ON"]
    # C API requires some clang extensions.
    args << "-DKFR_ENABLE_CAPI_BUILD=ON" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kfr/io.hpp>

      using namespace kfr;

      int main() {
        println("Hello KFR!");
        return 0;
      }
    CPP

    ENV.clang if OS.linux? && Hardware::CPU.arm?
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output("./test").chomp
  end
end
