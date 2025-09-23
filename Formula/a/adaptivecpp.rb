class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.02.0.tar.gz"
  sha256 "8cc8a3be7bb38f88d7fd51597e0ec924b124d4233f64da62a31b9945b55612ca"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_tahoe:   "5093a256125287672ee92a04e04ce4379d85b5ce7d8f708c42470efe2f45bda2"
    sha256 arm64_sequoia: "56365cb55d86a7b454113c72cef0b56f69e98fe74b608dc73487c8c7c038e063"
    sha256 arm64_sonoma:  "29339f025de0d565885c1d0bafc5df2a329e300d605b8e4d129b073308704890"
    sha256 arm64_ventura: "3fceb8a530c8bae51ed5c8d4fd86aa24ed44ced5b5989d8aecc35c15a13fcec6"
    sha256 sonoma:        "6df6cf68e6f7c6f76e86789fc2136cc59a9547ad8995a6f087b5d11be7fbc38c"
    sha256 ventura:       "50c5d104a5dca25f27873539b4406bc89e2a9c07af9883ca42ad9ded325247e1"
    sha256 arm64_linux:   "8624bd32feec638f2ed6a1e03722eab04cb79d61c6b0612bd3d4f8d66cf47f8a"
    sha256 x86_64_linux:  "26ab108dfc914eec16af31e9cdf6164da3f7d1cfa29b03a5d97566aad0646f9d"
  end

  depends_on "cmake" => :build
  depends_on "boost" # needed to use collective_execution_engine.hpp

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "llvm@20"
  end

  def install
    args = []
    if OS.mac?
      libomp_root = Formula["libomp"].opt_prefix
      args << "-DOpenMP_ROOT=#{libomp_root}"
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
      int main(){
          sycl::queue q{};
      }
    C
    system bin/"acpp", "hellosycl.cpp", "-o", "hello"
    system "./hello"
  end
end
