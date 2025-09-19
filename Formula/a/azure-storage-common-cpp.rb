class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.10.0.tar.gz"
  sha256 "84e165267995b8d10060abe1c2b65b3238eccea3f11222b5ae36042a1d1ae07f"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfc4473e8f88df608215057911934ede71f705f381128a0620a512a27236c6b3"
    sha256 cellar: :any,                 arm64_sequoia: "cd31d535ee1401d994c09820169460b836f2339b871175c1f3c986cfc74b48a9"
    sha256 cellar: :any,                 arm64_sonoma:  "74137549f3224e7fe9fe5bbecc35f8e6b65c168e0cb2292b98835b41dfc2427e"
    sha256 cellar: :any,                 arm64_ventura: "40512f12747dab26ebcf89379ad58a6b4521be1cbd4201d0fa9cf1a939e91457"
    sha256 cellar: :any,                 sonoma:        "ce3c59bca8833e9b323cfdc5cceeff61d5969ea79a153198da86b12c5c9253ed"
    sha256 cellar: :any,                 ventura:       "9622ca4cac0887dca6f77363701e4e797c27f7e59f545b3688fde9b14be85596"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce11c65cb890b8e651eae304e0f462198bf08ba50fba26cfe3fe50ac57acf0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c99f2c95d3e00e0aba6d96368e47f648171640bee7f08a3e430e7472553566c"
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
