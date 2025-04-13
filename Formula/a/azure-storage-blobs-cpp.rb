class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.13.0.tar.gz"
  sha256 "300bbd1d6bc50b8988b3dda29d6d627574a4f3e25a7e00a6986da5d3965f679a"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03efdfcab8216711665119c6d285eb344fa2dabcf5414e59108f857b0d6ce636"
    sha256 cellar: :any,                 arm64_sonoma:  "6ab8bc412b7a2c671305f6d8b000f03ba93587e7857b202d8f042718b74964a2"
    sha256 cellar: :any,                 arm64_ventura: "c10115c7de9b2c9965de045ed149cfdfcc7927eb9445c5195b11335c92813637"
    sha256 cellar: :any,                 sonoma:        "f8464e90a2e115ca726ed759df416a96575ea11aee471c4c9d4aa8efe11e7b99"
    sha256 cellar: :any,                 ventura:       "9c34e948570ad58b1838f052c34239e9ca75acd0ade38c4ea1a742ad05f9400c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcaa4eec2d79199bc6cfaeb000828472b7ad0e7c9bf0e3b8ca9c7e146a1eb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d63a09a4848a221ad75c3fe84ae5db7c7ef2b4f0e07617189b562eef175a242"
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
