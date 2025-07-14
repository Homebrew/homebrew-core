class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.16.0.tar.gz"
  sha256 "7f8ba547ef67290075ce148ba1769cf43aa9c7aeed1a62ac5f7ab521f6e68724"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "28731ac23463827c5229982675e18011900b1475673410b7a016022c9f2285c3"
    sha256 cellar: :any,                 arm64_sonoma:  "a4bf529ff3824edbe95c7b8f32c8ebb7929abc9ff95785e9169a45d0e7b9da79"
    sha256 cellar: :any,                 arm64_ventura: "f93ba1552f172bc94c52ffe5c221058ebded11d15e3407ab0560419a5e64384f"
    sha256 cellar: :any,                 sonoma:        "db868db17f450136245e812d318b513e69de8e118e39d2d3df94b7f67935fd82"
    sha256 cellar: :any,                 ventura:       "522bbd3366cf70b03aeeb621405b2b3ab82d2e1deb1cde3384709cb5f486f87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c488432247700bbe04b0dfa07f7a5c7ed5c21c1d4f072495937483de017bf61c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "183d19ab71ad3ddb9b2851a5784505eafba7e8a63ee974f393da9608f6a00955"
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
