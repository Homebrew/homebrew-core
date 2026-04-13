class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.12.0.tar.gz"
  sha256 "0d835b22c03358f6e837044c70b3f9d93902cf710c27ac9ee22b2544ffdec27c"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ae309bee78a0792044db2d52bd1111f0ed6be59df4256460dbc39474ac073d7"
    sha256 cellar: :any,                 arm64_sequoia: "580269d2771350c14ff9fc5bcb039eead21c8ac8ea1d3df114e17c9fb1ca77c7"
    sha256 cellar: :any,                 arm64_sonoma:  "1ae0d54395cd663b6ef394f386428ac38b27bf6ab92f20d5d15757ba168eb517"
    sha256 cellar: :any,                 sonoma:        "2c45d8be4428eaed7fcd3654c212180fe9382db207a3b25762b0d0bf2842928e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1114fa0b4fcdc27fbb36e3ef4b8064e8d75b374c43310027a5648ecf0cf78a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398233de7fe8306b5cee282f3d3c1d24dcef8b98263adcf8095c62deda34b6b1"
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
