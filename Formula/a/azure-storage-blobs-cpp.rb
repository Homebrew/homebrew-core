class AzureStorageBlobsCpp < Formula
  desc "Microsoft Azure Storage Blobs SDK for C++"
  homepage "https://github.com/Azure/azure-sdk-for-cpp/tree/main/sdk/storage/azure-storage-blobs"
  url "https://github.com/Azure/azure-sdk-for-cpp/archive/refs/tags/azure-storage-blobs_12.13.0.tar.gz"
  sha256 "300bbd1d6bc50b8988b3dda29d6d627574a4f3e25a7e00a6986da5d3965f679a"
  license "MIT"
  revision 3

  livecheck do
    url :stable
    regex(/^azure-storage-blobs[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2166f66228e15dbfec5a4b3a9b018315894999a3dd964307911b5204c678a13"
    sha256 cellar: :any,                 arm64_sonoma:  "a582b67789635f8deefa4040b5db2d4396a5288bdaeeb840df1d968ba96527bf"
    sha256 cellar: :any,                 arm64_ventura: "a81969ec7d165be0a9afe91fc1f937bd9f39fd5bc6b65a4ede2e9d46697ce460"
    sha256 cellar: :any,                 sonoma:        "ca5e7f10de61176ff6f0e965984fbda53ba086ac0842a902a2c2ff99b41737f8"
    sha256 cellar: :any,                 ventura:       "59451e49b613dfdcb8449eb13c29f3cdb49ef90bd766b1a40c9d147527937bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14baec69ebdcbb4266e41dbc600e5e90462a6db569b4c1b31147b1de6be7d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfb5352850893fe3e7a1c3b99ac2254552c13f1a5451ea183ced491890118674"
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
