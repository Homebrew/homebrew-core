class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/6.2.0.tar.gz"
  sha256 "bc9507e1dde17a86b68fb045404b66c5c486e61e324d9209468ea1e6cac7173c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "49dfce65d905f955ed60d8bad7b38d2620a6bb40bd98723c1be210a4c948e884"
    sha256 cellar: :any,                 arm64_sonoma:  "e1b3da51969be438e36b97e61d8c3fbf4852f311fa7fbc5e9036fef6372b3979"
    sha256 cellar: :any,                 arm64_ventura: "16cc7a6ed047cde918b0496f1291cdc6328dcd3c667d88b8a2ef0d037a54486c"
    sha256 cellar: :any,                 sonoma:        "c2ec1d0472a1920e6e51778354826ba8c7b6af29304f806f72cc6562e093ecbe"
    sha256 cellar: :any,                 ventura:       "da39d967e80fe3337c02545da188b66ad0d6d2ed0e29bc6d49883b6d2e5e1524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a18abab374376bdaaef8200d8d26e0a13c04d4445d6f4b1391eb7bb00164e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cbe7ca4c62fb5258d9433f7b6c690cc02bec561b057b5844e1942e7d0d8a28d"
  end

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

  def install
    args = []
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
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output("./test").chomp
  end
end
