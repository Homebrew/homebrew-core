class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/refs/tags/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "301f9864ac4d274fea2f67679ded8c0a9f4ddf8cab26eb94c9733923ae19af3e"
    sha256 cellar: :any,                 arm64_ventura:  "1fb69b507f673e6044199b6947d275517f867a476d3f2e1f4beea0298489b7f3"
    sha256 cellar: :any,                 arm64_monterey: "037c261fc9350737b6e614d34c9c7afc9afea7a9a31493148eda8e6a29099e09"
    sha256 cellar: :any,                 sonoma:         "810e5a5e3cfc8b13989bba7c792b6ec9625f82c06ac7e34b9794a97819ef2a1b"
    sha256 cellar: :any,                 ventura:        "f008fdef4dad1e636b2888f88cf3fbaaed5381caa3c6b415da06bb4e4334cd4f"
    sha256 cellar: :any,                 monterey:       "b29137dc6b6792c4e7c8a8d075e02010fac775a85cdd7129df1a53d7881e480b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b86271a4086bec9af65ffb841a9f0e4d2ceebba5852903306cf6109cf1c1935f"
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
