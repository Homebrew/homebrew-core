class AzureStorageCommonCpp < Formula
  desc "Provides common Azure Storage-related abstractions for Azure SDK"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-common"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-common_12.12.0.tar.gz"
  sha256 "0d835b22c03358f6e837044c70b3f9d93902cf710c27ac9ee22b2544ffdec27c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-common[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a91435621048f0d41b6eb35ec0ad61b9d30c7d4c711f6153d1ea6471972fbfc2"
    sha256 cellar: :any,                 arm64_sequoia: "eae30c7562bf07c527c03edcaeb1f2dd879972c7501d920bcac08b786069283d"
    sha256 cellar: :any,                 arm64_sonoma:  "367f76d8bf8edc5692418c3df029c82d8bfe1d147a9867adb19d6835d93a2374"
    sha256 cellar: :any,                 sonoma:        "b250e285389aa34812eff180741192077daff42a011c4cca0736bb6f788bcd42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5321dc11d109737db1b6d2f3dfdd1ab8e3021ab4691f188f3f019023fce79d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256271c571871019d0da999c828438ef746982f2ccf20984b039e44775bd0d36"
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
