class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.15.0.tar.gz"
  sha256 "00040ef20d25918eafd5e89e8c237d5a647810efb1466677fbe0cbb766213f7c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee0fe5e82e94b7afb9ab20b69b03c0fac96c06b04deadea7a2238d0777c60668"
    sha256 cellar: :any,                 arm64_sequoia: "9ef30c3ec542134106961931594cd2daa5aa0f94482094f7f3e9f97f61c8e6c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e684e0a234fe3de910d7c8e1f5fec412368f3939c43a78a681f6e12951bd529f"
    sha256 cellar: :any,                 sonoma:        "170a519183917482dd97204e5cbb2979c6e90e47ad2f2d0376f95bc41d0aeb7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c9337a8777f45e2f88ede3dfaa7dd588a37510de0f9325a72a66abcf904fdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f19943239844bbc08ec1012be4061af852a169089777fcc4977b9c72f76cbce"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "azure-storage-common-cpp"

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    system "cmake", "-S", "sdk/storage/azure-storage-blobs", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # From https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-blobs/test/ut/simplified_header_test.cpp
    (testpath/"test.cpp").write <<~CPP
      #include <azure/storage/blobs.hpp>

      int main() {
        Azure::Storage::Blobs::BlobServiceClient serviceClient("https://account.blob.core.windows.net");
        Azure::Storage::Blobs::BlobContainerClient containerClient(
            "https://account.blob.core.windows.net/container");
        Azure::Storage::Blobs::BlobClient blobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlockBlobClient blockBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::PageBlobClient pageBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::AppendBlobClient appendBlobClinet(
            "https://account.blob.core.windows.net/container/blob");
        Azure::Storage::Blobs::BlobLeaseClient leaseClient(
            containerClient, Azure::Storage::Blobs::BlobLeaseClient::CreateUniqueLeaseId());

        Azure::Storage::Sas::BlobSasBuilder sasBuilder;

        Azure::Storage::StorageSharedKeyCredential keyCredential("account", "key");
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lazure-storage-blobs",
                    "-L#{Formula["azure-core-cpp"].opt_lib}", "-lazure-core"
    system "./test"
  end
end
