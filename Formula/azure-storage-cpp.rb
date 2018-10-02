class AzureStorageCpp < Formula
  desc "Microsoft Azure Storage Client Library for C++"
  homepage "https://azure.github.io/azure-storage-cpp"
  url "https://github.com/Azure/azure-storage-cpp/archive/v5.1.1.tar.gz"
  sha256 "29b4b0c47784ae541b0ef1b3693acba54e0d06bac78d139105a379ab1fd20333"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cpprestsdk"
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    system "cmake", "-DBUILD_SAMPLES=OFF", "-DBUILD_TESTS=OFF", "Microsoft.WindowsAzure.Storage", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
