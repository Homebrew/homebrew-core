class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c561c69b4cf3677a619b4177651a9901bd8c37f6e00841ee7dfa779b0d2d610d"
    sha256 cellar: :any,                 arm64_monterey: "69077c839b19801a078f90fc5e75a51f7f8302095c6d90bdf91132e98192a94e"
    sha256 cellar: :any,                 arm64_big_sur:  "877bad6536d1b893d2aa4c54d09abdca4c97bbae3ddfdadbcfb412e2dedec05b"
    sha256 cellar: :any,                 ventura:        "9399d2818488907a12615aa6363cee42fb6951309feef2c9d84537368c01ecd1"
    sha256 cellar: :any,                 monterey:       "f0a9ef4475c97ca1b250efb8bcd7ea9b16b1468abe3aceaee24051e1ea3ce213"
    sha256 cellar: :any,                 big_sur:        "6b29bb83c1c4a15539ea3a138a9eeac481d02e9ba621868da1260b2083376a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9b09b5689f380ae2ba7070ba02e59af7e370b31cc56a07ec18094e597f8af95"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", "Microsoft.WindowsAzure.Storage",
                    "-DBUILD_SAMPLES=OFF",
                    "-DBUILD_TESTS=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    flags = ["-std=c++11", "-I#{include}",
             "-I#{Formula["boost"].include}",
             "-I#{Formula["openssl@1.1"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{Formula["boost"].lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl@1.1"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end
