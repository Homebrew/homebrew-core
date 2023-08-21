class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v7.5.0.tar.gz"
  sha256 "446a821d115949f6511b7eb01e6a0e4f014b17bfeba0f3dc33a51750a9d5eca5"
  license "Apache-2.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab552ebf3bdc993fc9e579e2a6b75759c9da2ae1be66951caf8f9e609d7a1800"
    sha256 cellar: :any,                 arm64_monterey: "46cd609d6586555b067f95d24cf0de532e40db79b0b3367c290d51cab751ce41"
    sha256 cellar: :any,                 arm64_big_sur:  "be9e3706cc237d12e7285ca3184b45681784905855e0f12e71457fdde06e980d"
    sha256 cellar: :any,                 ventura:        "30ff16a364d78d4ff1b0478c79262628c42f614a585be85649cdb6dd1ef9d37c"
    sha256 cellar: :any,                 monterey:       "412a2a4bc2bb9a1e8e350fc906b43bc1f6461efc36bc21246358b4ee0cea2c4f"
    sha256 cellar: :any,                 big_sur:        "cf309d60aec3a7898cb09864286a950332cda74e165f7c8d741ef8f74b1cdd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc25900db6d940de570b1196d2680d440be510bbadf5310208e3728b6b55ebed"
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
