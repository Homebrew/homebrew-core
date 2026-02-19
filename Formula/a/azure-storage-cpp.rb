class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp/"
  url "https://github.com/Azure/azure-storage-cpp/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f00202a3cc5f45662cb1bf801b41b41da1e6723ab96ae9a34d25cce65d62ff4e"
    sha256 cellar: :any,                 arm64_sonoma:  "66384afbbbaaf12285b727f25b3f6c21637183de034a0cf48c1d3c282f90cb67"
    sha256 cellar: :any,                 arm64_ventura: "6765f5fa16be2927c8fcf835d78ee871d3732ccea22a810177bf9f96df5f80f2"
    sha256 cellar: :any,                 sonoma:        "2ce10849c8309c5ce8244584ad2684d56e038228d93dd4116228518f4b28b847"
    sha256 cellar: :any,                 ventura:       "b8a14b220f1ad4e4c759146992258c51906652387a5aabaa924a296f31d37a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bdea74a09a3eec6da16d427c5570792e4793340d5f4fe88ba8b0d4b0e5bbf2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43fc31791da3f757934d1f122292cce81008d2af85f98284a7cfb89f9aab9104"
  end

  # https://github.com/Azure/azure-storage-cpp/commit/b319b189067ac5f54137ddcfc18ef506816cbea4
  # https://aka.ms/AzStorageCPPSDKRetirement
  disable! date: "2025-05-20", because: :deprecated_upstream, replacement_formula: "azure-storage-blobs-cpp"

  depends_on "cmake" => :build
  depends_on "boost@1.85"
  depends_on "cpprestsdk"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", "-S", "Microsoft.WindowsAzure.Storage", "-B", "build",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <was/common.h>
      #include <was/storage_account.h>
      using namespace azure;
      int main() {
        utility::string_t storage_connection_string(_XPLATSTR("DefaultEndpointsProtocol=https;AccountName=myaccountname;AccountKey=myaccountkey"));
        try {
          azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);
          return 0;
        }
        catch(...){ return 1; }
      }
    CPP
    boost = Formula["boost@1.85"]
    flags = ["-std=c++11", "-I#{include}",
             "-I#{boost.include}",
             "-I#{Formula["openssl@3"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{boost.lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl@3"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end
