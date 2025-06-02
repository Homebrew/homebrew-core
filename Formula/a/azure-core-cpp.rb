class AzureCoreCpp < Formula
  desc "Primitives, abstractions and helpers for Azure SDK client libraries"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/core/azure-core"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-core_1.15.0.tar.gz"
  sha256 "f13b41b1cf5ae8618909b2d30387cc83d9bbbf8fb7746e9d35196a524efcd3d9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-core[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30d61ea370900ba8294a01d9070d3bbd46fb590b36fe9f6c6d7d041048401223"
    sha256 cellar: :any,                 arm64_sonoma:  "c3da323ef6fb292758a5f11d7cc1e98ce61c8d229ab12dafa6a20d775e8569de"
    sha256 cellar: :any,                 arm64_ventura: "06c8fa36794a1efb84c6f1ac3c095b544f0af4ad0124785f804d4d7e6d3eed7d"
    sha256 cellar: :any,                 sonoma:        "a10a1c92d8dd81f47708e322b87e3d6d280bec8e6acd2b1e70db8170772c6b2c"
    sha256 cellar: :any,                 ventura:       "3105f2e4c4ce2a5c186b3afe51aec44aa53e134d01a3fa5fbb91e82f7fdd5ce9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7cee82d15aa5ecdcae5f66152ad32496e481f032d6a225fc0940bb386ae71eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1dfb2f1d8c34f60ef00962b733c50b583e2c9114f0c913b9ed082dd2a1dd513"
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
