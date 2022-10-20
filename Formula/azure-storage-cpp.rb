class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eceac6e6f0593179a3534c2eab359edf6649e7aa17dcebd8ae4440183e73ae5d"
    sha256 cellar: :any,                 arm64_big_sur:  "0d9d71cc5cf69d7fcb77cfc333c7e2d6c636f5bc3699a0f58c2efd0afb22e03b"
    sha256 cellar: :any,                 monterey:       "6b915ca380a9aef0e0d5e517570204f9f68ec019d7085ab8d3701c420365cbc6"
    sha256 cellar: :any,                 big_sur:        "d57014fd7bebf8938b6c9961e47454053778fd8055ef330df727d8e109d19474"
    sha256 cellar: :any,                 catalina:       "527e53429a66ab82caaf15b83c3cbc98e6a5fccc875d9a7111eff14daaeb6ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "897b6fd224578e6555f902d13428e11f8a2edee4b12c6cdee6f57928cd4c2350"
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
