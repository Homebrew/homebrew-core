class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.10.0.tar.gz"
  sha256 "334b16ebff373bd2841f83332c2ae9a45ec192f2cf964d5fdfe94e1140776059"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "b03aa7145c4c95b0eb07bb56a163742e17a95ca172958c93cfab371debbf94e9"
    sha256 arm64_sequoia: "20564093bcd1393f762ec007ede0922450ab60012db7bbfa5d723f9807909461"
    sha256 arm64_sonoma:  "8f2192a582cefc9512f60f14c6f2b8570f445c0ced4055553755f8760b2f0669"
    sha256 sonoma:        "ca9715cf73fc66f4f305ca7415be18cf892be66cb40e9e5cea1c0e21166e5be3"
    sha256 arm64_linux:   "8d14507b04a9f0e8e0480609fd5d1c421327817145b01f39474e05b78f7bd99d"
    sha256 x86_64_linux:  "4a78902bb2bc797d30058c1b31ac600bb07759f09178112d19dce02305367aa4"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "lld@21"
    depends_on "llvm@21"
    depends_on "numactl"
  end

  def install
    args = if OS.mac?
      libomp_root = Formula["libomp"].opt_prefix
      ["-DOpenMP_ROOT=#{libomp_root}"]
    else
      %W[
        -DACPP_EXPERIMENTAL_LLVM=ON
        -DCLANG_EXECUTABLE_PATH=#{Formula["llvm@21"].opt_bin}/clang++
        -DACPP_LLD_PATH=#{Formula["lld@21"].opt_bin}/ld.lld
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace prefix/"etc/AdaptiveCpp/acpp-core.json", Superenv.shims_path/ENV.cxx, ENV.cxx

    if OS.mac?
      # we add -I#{libomp_root}/include to default-omp-cxx-flags
      inreplace prefix/"etc/AdaptiveCpp/acpp-core.json",
                "\"default-omp-cxx-flags\" : \"",
                "\"default-omp-cxx-flags\" : \"-I#{libomp_root}/include "
    else
      # Move tools to work around brew's non-executable audit
      (lib/"hipSYCL/llvm-to-backend").install (bin/"hipSYCL/llvm-to-backend").children
    end
  end

  test do
    system bin/"acpp", "--version"

    (testpath/"hellosycl.cpp").write <<~C
      #include <sycl/sycl.hpp>
      int main() {
          sycl::queue q{};
      }
    C
    system bin/"acpp", "hellosycl.cpp", "-o", "hello"
    system "./hello"

    unless OS.mac?
      refute_match Formula["llvm@21"].prefix.realpath.to_s,
                   (etc/"AdaptiveCpp/acpp-core.json").read,
                   "`acpp-core.json` references `llvm`'s cellar path"
    end
  end
end
