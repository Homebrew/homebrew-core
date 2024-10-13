class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "715929b7bf9be66a120d8daaadef336fc4e69cc10b98bf57b1db566ed74c43ae"
    sha256 cellar: :any,                 arm64_sonoma:   "88c8ce8dd3036ecb8d825e45e4f540d3f85812a5551adbdff2f3e633a14971b2"
    sha256 cellar: :any,                 arm64_ventura:  "0980769654725aabfdaaf9fd7f5141bc3a80d283bd2926dd44271a96153b43ab"
    sha256 cellar: :any,                 arm64_monterey: "3c46568d7f4eb00aae073edb010631672d09ddf104aa58575d6e04717238d349"
    sha256 cellar: :any,                 sonoma:         "e84fce7243f0ec1b8d896c2534046348d28c50a67f44f37291a7e583f62025a6"
    sha256 cellar: :any,                 ventura:        "85412de563c1d2c57cd1dadf6ecc66eb18d3e0f051d5331771e7d593d144f169"
    sha256 cellar: :any,                 monterey:       "f5114b4ae18ac1ea2b3ee3c1a24618d910583b83dd848ff059414ecdff91aff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c89ec4ddedce0b55bbf1f97de363abf7e2778b39a4363284a642f6215f116c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
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
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
