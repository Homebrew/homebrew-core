class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "aaceb62409cbe62a5035b82c154995156cef409179489d6a99ee86ab5888b179"
    sha256 cellar: :any,                 arm64_ventura:  "e77c4f6c284c3efe0dc582370b5898f457f66d0a9820d3eb8593503041b2989e"
    sha256 cellar: :any,                 arm64_monterey: "4cddb051be494abd045720d99b472bb9870ef510d2c9705674f729df389ca16e"
    sha256 cellar: :any,                 sonoma:         "c67db0a3935d909fa31566170c206c0f24928f4f1a96c3a8c41c95fa7a8d6907"
    sha256 cellar: :any,                 ventura:        "9728d2912cc06f7a79b2597086c1473733954d47d8e0f639ba72c1be8f4e7ecd"
    sha256 cellar: :any,                 monterey:       "d336db4b98c57839cf799e1eb00ddb76066827a1f8417780b14ef62a2dc9c8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c6e5f28c8d2817eda356744457b1704f71ea07a2514cef0079a655cde717d5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "openssl@3"

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
             "-I#{Formula["openssl@3"].include}",
             "-I#{Formula["cpprestsdk"].include}",
             "-L#{Formula["boost"].lib}",
             "-L#{Formula["cpprestsdk"].lib}",
             "-L#{Formula["openssl@3"].lib}",
             "-L#{lib}",
             "-lcpprest", "-lboost_system-mt", "-lssl", "-lcrypto", "-lazurestorage"]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cxx, "-o", "test_azurestoragecpp", "test.cpp", *flags
    system "./test_azurestoragecpp"
  end
end
