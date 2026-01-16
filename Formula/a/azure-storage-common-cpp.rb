class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.12.0.tar.gz"
  sha256 "0d835b22c03358f6e837044c70b3f9d93902cf710c27ac9ee22b2544ffdec27c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56399b3f6aeba1210fb56f531b568de1b715768b4bb9a0e5e9ab7981108b2703"
    sha256 cellar: :any,                 arm64_sequoia: "3982b8527bac566a4edfe206706761346c20c4e06851f950f0046bd44d80588d"
    sha256 cellar: :any,                 arm64_sonoma:  "528ed52cb607b49a5755cb956f27948f45262781db72f636832a09a8498709fd"
    sha256 cellar: :any,                 sonoma:        "4fd56e120526ab6f616e6b02c4f0cb8f596ea460dc73d1ffda551876e0d1596d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9dfafc90d98b60930047e2edd28c916a01058f4cdd75ede6b96ce9daf57d283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f33b1ad8355863eb217b16febcfc781e511185da577ae992926e64243b34ffa5"
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
