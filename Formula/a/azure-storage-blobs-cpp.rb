class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.14.0.tar.gz"
  sha256 "5ebd63d6d5c22702b504efef1acf0265ceff90dcf96b9c1e52c418bbd7c5deb4"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "931d74b23882d65838aa1dcdee8b8f5c6a712b92e8e67ef67046fa63c7e6b0fc"
    sha256 cellar: :any,                 arm64_sequoia: "817d7f2c752d012232104d5396c1c90878223b8dc83a6855e7e12a2e16b1e8a2"
    sha256 cellar: :any,                 arm64_sonoma:  "149c06c8e6c669a6d34d1b94ea1b9738ef1ced29bf2d651badf107592907bf21"
    sha256 cellar: :any,                 arm64_ventura: "cbefd41db33f1e410ba5b3af57ba385415d5d72065232fa5a6edb71d8c8779c1"
    sha256 cellar: :any,                 sonoma:        "6086b38c930f68cb1086d6f8b73174a0875fc615000b0bc19cac84f38e45a8fe"
    sha256 cellar: :any,                 ventura:       "3ff8c1e5740fe092ee9a31d50c03903f3ddbfed889528539ba6fb085ed9b70bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098cc370a127b763ae22d4032b92e15ff1ebbaf9e527ac756318dafcef8fbf7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a0241a93ca1c9394edcc281822a285cf51209f52bf5cd30c7bb4dd06ccb054"
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
