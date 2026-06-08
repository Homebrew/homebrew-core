class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.13.0.tar.gz"
  sha256 "3c24422456c90a9e43b5edc6e9098397309318a0e0eca3fd22a56e94b7c3ccf9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1432ccb23ee03b84405c1e2c2cc600e6cbf9f99b2a46479eddd14f1fad7d898e"
    sha256 cellar: :any,                 arm64_sequoia: "812f97440320ac6780635aae9b9b747798cb05332abd2310de14de0f829eaad0"
    sha256 cellar: :any,                 arm64_sonoma:  "15256f7d0f98e52b3996f0690ea5db3d17e9db7f62c570b41313a2db3a26b65e"
    sha256 cellar: :any,                 sonoma:        "b66a66afb74c13e9ca95a5bf3be5eda63a78bf6b9068be6b46ecc023af488857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b6081d14cfb9eebdf61c077050a781a1e6b6d01281343b8f7f40a9733c47d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89309f6c1ec39b7d2d965965f4d9421e951fe99e386d365eb34b853f54c64a61"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/storage/azure-storage-common", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-common/test/ut/crypt_functions_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <string>
      #include <vector>
      #include <azure/storage/common/crypt.hpp>

      static std::vector<uint8_t> ComputeHash(const std::string& data) {
        const uint8_t* ptr = reinterpret_cast<const uint8_t*>(data.data());
        Azure::Storage::Crc64Hash instance;
        return instance.Final(ptr, data.length());
      }

      int main() {
        assert(Azure::Core::Convert::Base64Encode(ComputeHash("Hello Azure!")) == "DtjZpL9/o8c=");
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lazure-storage-common",
                    "-L#{Formula["azure-core-cpp"].opt_lib}", "-lazure-core"
    system "./test"
  end
end
