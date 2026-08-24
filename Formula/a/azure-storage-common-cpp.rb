class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.14.0.tar.gz"
  sha256 "68b3d88d5f1358b3607b4fb76674373c91e1dd840920de05e5a82cf09fcc6e5b"
  license "MIT"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2d914c191a9eb1296b8b37238e7c519e3af7d8a60d9673c5af5f82ff053f73c"
    sha256 cellar: :any, arm64_sequoia: "a7dcf5922c055a18da2ad78b611c7e707ade1e115007578e097e1468355ab5a8"
    sha256 cellar: :any, arm64_sonoma:  "5ad44e27669167fb22b00026ab8ed38b4ad456de277ce8bd95c939b8141da6b0"
    sha256 cellar: :any, sonoma:        "b8805b24efce0ffd2ab6f63c8ac80bcb512a4607dc925122dea6ff4e742d02a7"
    sha256 cellar: :any, arm64_linux:   "a577bad4ab187a026340ad4d4ef32af18627957041d0137b6593b9002256796b"
    sha256 cellar: :any, x86_64_linux:  "04542da5a420d6c2a456a8f1665f9c25e5e391bf80346087a41481b820fbb8a6"
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
                    "-L#{formula_opt_lib("azure-core-cpp")}", "-lazure-core"
    system "./test"
  end
end
