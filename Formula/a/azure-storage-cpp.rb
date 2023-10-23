class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bc4cb251618870f0a409a992d721bb2ee42931a220fa2e4c845a1973b71764a"
    sha256 cellar: :any,                 arm64_ventura:  "dba71aa9c5484a25ef89187163979735d645eba1f88d7d424fe994502ea7df27"
    sha256 cellar: :any,                 arm64_monterey: "034dcfbb9f56c28eba5d07d74f76ae6c091c9e9480138b7d1e810f89d83d6334"
    sha256 cellar: :any,                 sonoma:         "cd544f7d3b75c30b84b1279c5d7fe0fa8e7e1cd76dbea530eb172785e6862a98"
    sha256 cellar: :any,                 ventura:        "1779aa8d72752a5134f3782b042ef647fba38b78e866e3ca4ae169018673adf0"
    sha256 cellar: :any,                 monterey:       "6a3781a788553d7fa7e115544aea8967caff24a503a2b601b640dcec8566b50d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7e2306012855a6e9c341f710b07580132b8b5c5bb8d35b21309643f9891c85"
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
