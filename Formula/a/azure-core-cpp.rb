class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.14.1.tar.gz"
  sha256 "e0173a675363463c63f52a215e4b3f1bfb28c901d70fe7eea420b5dc4aa591cb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35dd75437ffee884b48f62fcbf9b78d0166d08943990af00d3b73ec8847ee28b"
    sha256 cellar: :any,                 arm64_sonoma:  "7cb7895078ff88f4bd2b1495bc567b06d9c2d7beb1ddbe97a245ae525a6aff2a"
    sha256 cellar: :any,                 arm64_ventura: "01a5bb7fcd40b9e7203db81a3505dc44fc295fb48cabea1a2009b8bb63688197"
    sha256 cellar: :any,                 sonoma:        "9808cb4439c393a94a69033c5190e999648b3824d0b38122609d727a0defffed"
    sha256 cellar: :any,                 ventura:       "c641fe6c2e5a32df63d61ddc4a21ef04d04e25c92d42da3c434a02201ef67b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1901b330cd4461a948c90d730cb3dd3b9afda6495151712ab168bb1bcf5c72e"
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
