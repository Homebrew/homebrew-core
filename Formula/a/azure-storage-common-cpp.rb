class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.9.0.tar.gz"
  sha256 "bb465f2e05bb4356dcf3bfdfd149a8727e222452f76a63d51c853513c0e3de1f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f07897053b2eb41eb11229b6cb6a4040840bd8cadae47934d1b6b90e1fff72df"
    sha256 cellar: :any,                 arm64_sonoma:  "214bcb7ebdded6e6e6db2467bd0d35dab8eb4e417f66b63dd17568e5724f5584"
    sha256 cellar: :any,                 arm64_ventura: "a4604e47a183e51c56226b17f0030617219baf7e2915fcdce3bb9453242e685a"
    sha256 cellar: :any,                 sonoma:        "6f729a47c25866a27cc410b052c4738c203dfb7a6f26f83dd3a8e16c7e9891f5"
    sha256 cellar: :any,                 ventura:       "9e5cfb5a0eccd57c23af032175e1125b387415d60b8742ecd076ff932a82ee2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd47c8d70aa9f4035ed52b17b9285c028c88e89138d0b9d92416fe741263cf7"
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
