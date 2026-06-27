class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.14.0.tar.gz"
  sha256 "68b3d88d5f1358b3607b4fb76674373c91e1dd840920de05e5a82cf09fcc6e5b"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "814ad310d0b7adba81bb9e2cc11217d8945bf9c82c7806113cf576d59bc4a3f9"
    sha256 cellar: :any, arm64_sequoia: "473115bf466b5489eb0570e2750a254a59ce173a6b734c17879a181c827c9663"
    sha256 cellar: :any, arm64_sonoma:  "3c201c24e5e456cb1bb1ccfafe0d529dd9e57f1302520349de0ab29b3da04cce"
    sha256 cellar: :any, sonoma:        "cd76a1b84ba3dff09bd030d474d28c724a484ccd8915eec88a2e00e83d6a4b2b"
    sha256 cellar: :any, arm64_linux:   "0d2f4af9a49d4f67cc3bfdc3f225b3bcdde086f7c0a47e857f411f77e550898a"
    sha256 cellar: :any, x86_64_linux:  "6fd2701ff2981b1f5497dd3583e2178ba7f41fd286033e75802ac906694c6b41"
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
