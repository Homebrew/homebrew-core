class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.13.0.tar.gz"
  sha256 "300bbd1d6bc50b8988b3dda29d6d627574a4f3e25a7e00a6986da5d3965f679a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cb6b42324abc38c5297be494fef26300d16d68a88fdbe1df4645f1f1b0ebe01"
    sha256 cellar: :any,                 arm64_sonoma:  "f2011c1a37ef61aff9cd77e9d218eee42754a1eb80a8972182c2e70b23131a2c"
    sha256 cellar: :any,                 arm64_ventura: "8a2daa496708ac76de0b7834c1b1cc572e5a17a96d14b1347d76e1fd04be6ac2"
    sha256 cellar: :any,                 sonoma:        "1b0611992e23c76d3ed8a663934ea94b5234d71fa68936ad7e9491912492a7dd"
    sha256 cellar: :any,                 ventura:       "83d7b90ab7086f61b121ba374eb9bd1ac05f4c3f33964d1ab8823889fd5ce70a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4451a392473b4d4aafb8ac8f631d9eededb7851751dcb1064b5681d426d9a9f5"
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
