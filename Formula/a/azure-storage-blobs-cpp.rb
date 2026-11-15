class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.19.1.tar.gz"
  sha256 "2f7af311f5c21b3eaf797d3184b50ac741652e534b3b3d0346a4bb88427c6d06"
  license "MIT"

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ed45a9d119d79c047bef23b195b26a9b0255ffe2c8c95af47f6ce26b71dcec99"
    sha256 cellar: :any, arm64_tahoe:       "c1e51cc60ca8da830bc84c388af32f569450bd4bf8d445774c3f9b94ec7be9ef"
    sha256 cellar: :any, arm64_sequoia:     "8c0a14240cdea8bdf090ccbd6a8c652751323530940892817969f2922ee248e9"
    sha256 cellar: :any, arm64_linux:       "3140220cc4bf7d14d7e8c7adfc9ab819a83eea27d0e7ad47136e0ec4dbd0b68e"
    sha256 cellar: :any, x86_64_linux:      "355b2b15130adefa764a655510ef551b5cbb9216fb23535d77e31a9ce11fc62f"
  end

  depends_on "cmake" => :build
  depends_on "azure-core-cpp"
  depends_on "azure-storage-common-cpp"
  depends_on "flatcc"
  depends_on "nanoarrow"

  deny_network_access!

  def install
    ENV["AZURE_SDK_DISABLE_AUTO_VCPKG"] = "1"
    # TODO: Remove when upstream supports shared flatcc: https://github.com/Azure/azure-sdk-for-cpp/issues/7437
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DFLATCCRT_LIB_PATH_RELEASE=#{formula_opt_lib("flatcc")/shared_library("libflatccrt")}
    ]
    system "cmake", "-S", "sdk/storage/azure-storage-blobs", "-B", "build", *args, *std_cmake_args
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
