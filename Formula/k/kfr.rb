class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/7.1.0.tar.gz"
  sha256 "9ca43ee8f0d7b166c92f06d20953d2a753774c4237b2721bea366115811dff64"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8c0e575d71338be7f1dc85558cca4839ae8881d1c47cbc0c911ce2e099d0e10"
    sha256 cellar: :any,                 arm64_sequoia: "edea10b7dda7aa1faa2df0a8c2e9c120619099d6ae120937a4683a2d45a6065f"
    sha256 cellar: :any,                 arm64_sonoma:  "a0b2530179442951d697cd7dec0d9ae8de395787e275947cf0bb636f589f7eff"
    sha256 cellar: :any,                 sonoma:        "8046d3d9c76ca7c1cd0a728aa41804ad9f90d1910fffba6ac4bac9da4c464348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f171b125283cf0b0e8c0e091a667cb506650fee41bd9e61c8c723f0470951e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "846fedfb8e6c84c1a7915efe85ae15fbf788187051c8a6c76c99a4ddf8628397"
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
