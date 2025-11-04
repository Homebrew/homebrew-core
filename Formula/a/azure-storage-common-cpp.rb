class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.11.0.tar.gz"
  sha256 "456c95bf5c723ae4f84202faa45a0644b8f25b34bced37dce6b6afd854c17936"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5d3308f10f7eff56ac3913efee810fb44ef351a192ddec1040494787e8416ab"
    sha256 cellar: :any,                 arm64_sequoia: "00fc8aa5dc515606eb23bab63a4d27484dbe3885b291e189fabe3c9e2a94f197"
    sha256 cellar: :any,                 arm64_sonoma:  "d69c75cd6f6c9c0426757c077666fc8853087731874aca9c733272a6ab4f5502"
    sha256 cellar: :any,                 sonoma:        "8f83d43a40fc0efc75535cbcd33414def4e880708a20af1dabb89d57d3634487"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d0469fe2eb85c03b74e95c7c402bf3d133e6e1bf4590601bac46570c9e0f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b075c2b0520e483c04e8b57569e6876f14a455c9b8d2ae997d9c993ac6c84d5"
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
