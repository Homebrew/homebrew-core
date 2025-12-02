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
    sha256 cellar: :any,                 arm64_tahoe:   "5176a2dc38445f2ebba5131252f5e47117ccaaafd56816c4e42f52aae0035397"
    sha256 cellar: :any,                 arm64_sequoia: "875b5a4f1e2b4423190cbe7635e6c6d5b71b0d4be5e91f475c4027134fe7e69a"
    sha256 cellar: :any,                 arm64_sonoma:  "fd5d1ac903b7d11707e72348e8578700e95b2adb5ed2aea8f7bd18d574373cf9"
    sha256 cellar: :any,                 sonoma:        "a9b2753a1ddf6eeaf15f0a574dccd47d054ac585e34618860d86b46fbcc2d5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a84c2fd339935ea456227bb7327c6147659419f9d3ac18e485141c43963a76a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff9e45aa7c42b6f5130af29e3c3627004d39fe826e59f59d4d6ec2deb7df1d9"
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
