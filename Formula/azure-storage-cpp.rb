class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bf2dc9dc42639f6a174ed7a18fb098aebebd65fc8042b90a512a3d3c455b3cb1"
    sha256 cellar: :any,                 arm64_big_sur:  "44c92708a069bfbb747e7710ce65e20262dfd4bb67311b832639ba201a72ea7a"
    sha256 cellar: :any,                 monterey:       "04721a7d666cb92d8ac4b4484be3ee76d745cd1a5bd08cdae2683e1c15704a84"
    sha256 cellar: :any,                 big_sur:        "2c530902c523c7ccdb2d4514145c5c86191e530b0d88d1594f5f2716f6fc87c7"
    sha256 cellar: :any,                 catalina:       "161ddefac718948838ab878191c45a1b6180f05598ae121401ca63e3da1b672c"
    sha256 cellar: :any,                 mojave:         "4abae4ebc74f4758f5be5fbc7846467eb5bf429b596c31eec32f53026d65251e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf06755b0fc3414ff7abe7b9a7bbfbc61d62c86f0512fbfbe5cb4023500a7ac"
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
