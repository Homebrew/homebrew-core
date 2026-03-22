class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.2.tar.gz"
  sha256 "647d7206a1eace0664ab8da9912fada0ae1d269097ee5f6397a9ce23a84549cf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f20f2c19794b282c02ea7229aaa6e1dc242058a9125596368fa6fec83ef3d24c"
    sha256 cellar: :any,                 arm64_sequoia: "5a7d9f375df39e050f71fd0af44e7bb50e42e40fc399fee62d50b9b3ca01d751"
    sha256 cellar: :any,                 arm64_sonoma:  "f5d107e1caa9b960a1fe6cc79dc2d65a02683f1ccd2635385cf8eb22c66b28de"
    sha256 cellar: :any,                 sonoma:        "14f574f33c5b0252eea9eab4761f21ad925628c1806078254d754e6db9bd8516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dc622fddaeacddc5665ac5eaf264b68f795a2846f25b02288d71959a4f25ae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0338cd373609bdb1431b0384d9215120c9160402bb9f71c610fcc12cbb84dd"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/core/azure-core", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/core/azure-core/test/ut/datetime_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <azure/core/datetime.hpp>

      int main() {
        auto dt1 = Azure::DateTime::Parse("20130517T00:00:00Z", Azure::DateTime::DateFormat::Rfc3339);
        auto dt2 = Azure::DateTime::Parse("Fri, 17 May 2013 00:00:00 GMT", Azure::DateTime::DateFormat::Rfc1123);
        assert(0 != dt2.time_since_epoch().count());
        assert(dt1 == dt2);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", "-L#{lib}", "-lazure-core"
    system "./test"
  end
end
