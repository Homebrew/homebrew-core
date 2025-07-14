class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.10.0.tar.gz"
  sha256 "84e165267995b8d10060abe1c2b65b3238eccea3f11222b5ae36042a1d1ae07f"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a065a2c29588cea2c0124c7bbdd0c46c75600f51083af00ea46fa9028095779c"
    sha256 cellar: :any,                 arm64_sonoma:  "3af36e9cfc269ef9d8fbab406e540a774e9ed2e4e7fb75c3ef6340a78733d3d3"
    sha256 cellar: :any,                 arm64_ventura: "5e644150722547c31d29a8b1e8c36397f92fe7ecb565430daabcadc9c7a4b0d7"
    sha256 cellar: :any,                 sonoma:        "e0f8c21318c011b37fc5d84a87c1ae399e716fb02daa63c92f54e234e2827b92"
    sha256 cellar: :any,                 ventura:       "5f8c7fce113eb7177fdf386529fddb23b27dd2adce1d682b4e7276a2bf27dafd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02c97f2bd6c78714cae77ac3f6f622596a7683e9b7027f731329e65cd9412da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff033467e0d9cf754b645350476fa81c58643bdaa3e8ae29f1f5879187cac79"
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
