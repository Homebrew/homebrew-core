class Adaptivecpp < Formula
  desc "SYCL and C++ standard parallelism for CPUs and GPUs"
  homepage "https://adaptivecpp.github.io/"
  url "https://github.com/AdaptiveCpp/AdaptiveCpp/archive/refs/tags/v25.02.0.tar.gz"
  sha256 "8cc8a3be7bb38f88d7fd51597e0ec924b124d4233f64da62a31b9945b55612ca"
  license "BSD-2-Clause"
  head "https://github.com/AdaptiveCpp/AdaptiveCpp.git", branch: "develop"

  bottle do
    sha256 arm64_sequoia: "fa1c355b2af0934de4aae2fdb882f7befae852e5523ed4b3f4270d69bfd46edf"
    sha256 arm64_sonoma:  "c01a61e3a4629d1c1c52ba7d9f5f0618f6b7f6a246d25da96c4e0ed481f0b6bc"
    sha256 arm64_ventura: "99b96eda0511b4d0cfabc9580e41231ba4e6ab7ff8c999d1a806666272b277c8"
    sha256 sonoma:        "0f36be03113ad37c5c5dd608c4eaf31c4e81140b55266b7576315f1bf2fc8e0c"
    sha256 ventura:       "55be476775f893b04c942a69b19e049e7ae08db67069f7a30197b2e56d0df3f6"
    sha256 arm64_linux:   "960d8324f3d0d1c041e22f8a5a49f4267b0869ba55a6e2aae6352cbf597cbcb3"
    sha256 x86_64_linux:  "83441ea7d08eca12a414c7b27717d047140a482497e9f74f8d40a69da6745513"
  end

  depends_on "cmake" => :build
  depends_on "boost" # needed to use collective_execution_engine.hpp

  uses_from_macos "llvm"
  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
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
