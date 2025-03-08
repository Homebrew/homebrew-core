class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.9.0.tar.gz"
  sha256 "bb465f2e05bb4356dcf3bfdfd149a8727e222452f76a63d51c853513c0e3de1f"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6cae1d394b0458fdcb8f0c80b53cc680b288e3f147d29902703a784b5e90e358"
    sha256 cellar: :any,                 arm64_sonoma:  "5df790f89e99c0246e85cc7232cce0ecce9c08407ffa27b3579193616bb6702e"
    sha256 cellar: :any,                 arm64_ventura: "5d16d6897d31e1487aec705fa2749ef327d710c55fe86bd00a850323adfb8ed4"
    sha256 cellar: :any,                 sonoma:        "9231b85fda3043b599379c5c62210cb81892888a80e89b0b30d67836fd948c37"
    sha256 cellar: :any,                 ventura:       "b962871c3492a99882e60520c6fe2b2c36fc37a0409601e0952d4be59a7ea2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c8069c1eef35244891780d2245c8b53b283b1cb29d619460aa30f1cf450b9ad"
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
