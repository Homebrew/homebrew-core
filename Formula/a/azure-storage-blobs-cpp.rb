class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.18.0.tar.gz"
  sha256 "0f266f91cf00b79bb6c7c6f99e44942b43a7141db565556a4298f6ebe3a86fcc"
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "17a5a668525bcddc4b2753ba6d6dac3315c95c167e7877fe8193e0cda2473374"
    sha256 cellar: :any, arm64_sequoia: "1f01e4a760468d2275e2ccb52d7b5b1639360f8d9c822eafce8820c483dd7d4c"
    sha256 cellar: :any, arm64_sonoma:  "7d32add0d3f3a65f764eab16b38ee74d4d13cc5785bc0847c0113a22cee971a3"
    sha256 cellar: :any, sonoma:        "2ddba0694b0a8542e2a3780f83bae50706d99d4291bc2803812ff804837dd8ce"
    sha256 cellar: :any, arm64_linux:   "585dfe93c06704647a0a1bf304fb4d864f7d389ec56bf3de93a3be5163d9eb5a"
    sha256 cellar: :any, x86_64_linux:  "43e4b1122b3a153357a0eeb79e81ae982b7ae8e6d7d0efb53586b7e8b0988557"
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
                    "-L#{formula_opt_lib("azure-core-cpp")}", "-lazure-core"
    system "./test"
  end
end
