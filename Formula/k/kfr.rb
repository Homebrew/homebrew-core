class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://github.com/kfrlib/kfr/archive/refs/tags/6.3.1.tar.gz"
  sha256 "800f8e782fb514176c06526792ec766b718a7b91c73e9d07efe47dff6cb0816d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d65fd46b2a018d8c3883abe488d59b72d8a00d460cca2ce3b9104c5d28c19dd"
    sha256 cellar: :any,                 arm64_sequoia: "4a40ed9aa7acf145d621cd8f9be785ceb4c407c3a643f6c8b6660b165669bc61"
    sha256 cellar: :any,                 arm64_sonoma:  "87c79c3fd421eca89036c1a8388f3854712b2d95c33a32f05201acd2bae6aa98"
    sha256 cellar: :any,                 arm64_ventura: "c543be773e9fb85454d10caa84ba4376bc3ec7754d23666492b9b9cc7a8d32b1"
    sha256 cellar: :any,                 sonoma:        "28e2d7452615d264273d80a987f467afdd97c6226319300b5a996eb9e8b22fcb"
    sha256 cellar: :any,                 ventura:       "ed5e474cf383ffa11c93bcf1d8f29bf698e5124c67b77c35566d1dd2741a9c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "132ef75675095a38000e4438b30fe114160f6ece8669d96074883fde5ce1b586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4af49f21a57943e0891c293c7cb6948d0d04ac04c9f4691bb57889c7416df32"
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
