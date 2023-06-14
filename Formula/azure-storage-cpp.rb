class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d69bfaf5663a06d56e6a5543f8a969d520a46c5e09e8c40fc22cc1141a97e91d"
    sha256 cellar: :any,                 arm64_monterey: "3abe006019c8b247ae815c9c9d363bd54e005b6c9455b49ca6ef9796009923bb"
    sha256 cellar: :any,                 arm64_big_sur:  "3fe374b2484e3a954c9433889e24a04136ad0744b041838dd33ca6b6aed75fdf"
    sha256 cellar: :any,                 ventura:        "27c77976b99290796c83280f60e374073191f3dc8a6278ecb8ef939c6606b92d"
    sha256 cellar: :any,                 monterey:       "0b0e9560976766c7cf159a68d28bc11726831b59e2e0900a3840e7a02514d6e0"
    sha256 cellar: :any,                 big_sur:        "b80230b855850c0958ca8987a3a05f361c3b567973e228c2356dd8871442432c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c55f652a04448f4d98f5db1386ee99b2235cbc27c59171bc141597f7e8b0a7"
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
