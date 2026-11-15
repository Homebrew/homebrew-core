class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.15.0.tar.gz"
  sha256 "23a10c84418f6d8c07858277f3b8e7c7344008f1ab9eacabdc485fb0744903e5"
  license "MIT"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee1f9ed0ce8e806de4e0bde1e60cf28296ac9b211369cbff843170859d154ca1"
    sha256 cellar: :any, arm64_tahoe:       "7428638c7d38903793b71671ed2e140b4a632bc9ab7ed7ffad82acdd46741298"
    sha256 cellar: :any, arm64_sequoia:     "53413259ed5b38e9c0d78b73a83ea2904c3eb39fe20cb93aa8094eac7331d1de"
    sha256 cellar: :any, arm64_linux:       "08d585a80c652a38803b13d95f76d942621d579ce42846ec6a19e2032fd04303"
    sha256 cellar: :any, x86_64_linux:      "0f1650f49d7e0b0fcee3b7f827bf6e3b82f40d30b5e958b8a67474036dc5a9bc"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "openssl@4"

  uses_from_macos "libxml2"

  deny_network_access!

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
                    "-L#{formula_opt_lib("azure-core-cpp")}", "-lazure-core"
    system "./test"
  end
end
