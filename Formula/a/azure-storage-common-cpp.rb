class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.10.0.tar.gz"
  sha256 "84e165267995b8d10060abe1c2b65b3238eccea3f11222b5ae36042a1d1ae07f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e3e595864a4e6e78be91cd69b3f3a924cd2308c4411ab31b5872a0582f280dfc"
    sha256 cellar: :any,                 arm64_sonoma:  "dd768e2e9d449d65e3a7464dba91a3ccdbf6c54d5e6ea03cce8265e5002697bc"
    sha256 cellar: :any,                 arm64_ventura: "dc2dc8eababf52d0ab281def32b86a9ce85b9fbb59fe04c2f086b45a19a3d259"
    sha256 cellar: :any,                 sonoma:        "5b682a27014f02949b583a560543dab0e120b96d80ddb18a07e85106cd7a8154"
    sha256 cellar: :any,                 ventura:       "0763d2ae9a0627a0d4aa85a796aa8caa1e1bc15f42effe4f06c6e6d90d23ff80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "867c5706223bb8d2346753f25df15b65cd40e70a4b728c557b8108e5d9095049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f5735cd592ecffff5bb6bb5cc447a4134b80bf7256df2e47c3298a721b347e"
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
