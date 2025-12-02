class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.10.0.tar.gz"
  sha256 "334b16ebff373bd2841f83332c2ae9a45ec192f2cf964d5fdfe94e1140776059"
  license "BSD-2-Clause"
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "47170783eb0de616f48a47f956ead8d7940144c6d942c068ec47d6b5039800b4"
    sha256 arm64_sequoia: "2541023a8c2434dfe59c6e8fe3da3092c238aa253fe6cb3584e16dbd8b3b4890"
    sha256 arm64_sonoma:  "e9c912e6c181be13a3238c9ad4ae3c8d55c367717872955ba471066cd08fe375"
    sha256 sonoma:        "3084318448f81ec7c534cdc5533c8e04776e609a7a3749e8494c5b957f35dfe5"
    sha256 arm64_linux:   "0cb9c3ee690bb883104eeff0bef2a0961c194f63e37779dcff364adeb34a8571"
    sha256 x86_64_linux:  "6b697146bf34c4d6ec13b85483297174f9e88e5b989d0af56abdc38ab44ccce8"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "lld"
    depends_on "llvm"
    depends_on "numactl"
  end

  def install
    args = if OS.mac?
      libomp_root = Formula["libomp"].opt_prefix
      ["-DOpenMP_ROOT=#{libomp_root}"]
    else
      %W[
        -DACPP_EXPERIMENTAL_LLVM=ON
        -DCLANG_EXECUTABLE_PATH=#{Formula["llvm"].opt_bin/"clang++"}
        -DACPP_LLD_PATH=#{Formula["lld"].opt_bin/"ld.lld"}
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
      refute_match Formula["llvm"].prefix.realpath.to_s,
                   (etc/"AdaptiveCpp/acpp-core.json").read,
                   "`acpp-core.json` references `llvm`'s cellar path"
    end
  end
end
