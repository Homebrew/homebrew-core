class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/7.2.0.tar.gz"
  sha256 "4f1603d5b6e609c25d25cff58fe7154a371583fd6d379615b342e44223be0763"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3549e334cf37a900f937f514089b140c0d37a30fc125a2f1af7ee4a591f6ade5"
    sha256 cellar: :any,                 arm64_tahoe:       "eaa423a0e46ad5b7ce41783521a9528589526dd199c028813effc3c5daeec79c"
    sha256 cellar: :any,                 arm64_sequoia:     "ca6b3cab25a9414b0ed1985d5effa9ae75d6e92a807005a5e308670147c642b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3bc284fe2d08bd24f52968a88745ba20b192eaa8b5050f6835d5b24111cec8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f03134333e0dbc59dee0343b3c7dee2636f84f48c558738e24d6822fbe4967e8"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build

  on_arm do
    # FIXME: `uses_from_macos` is not allowed in `on_arm` block
    on_linux do
      depends_on "llvm"
    end

    fails_with :gcc do
      cause "ARM builds require Clang compiler"
    end
  end

  deny_network_access!

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
