class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.3/poco-1.9.3-all.tar.gz"
  sha256 "583c464cb2a85a1b0d1bded22875a929eabca54b1575124b114dc4f7e573aa68"
  revision 1
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "b1d99b95f5db087fd940730f1a18b10150678222545becc5930b1d82b4fa8291" => :mojave
    sha256 "e81534b6338bf2ee789a34c58947f460a30f02df717bf88b6cfd2045424646e5" => :high_sierra
    sha256 "c4c316c9c37ec16007d688e2fadda3c9b704914d63a8cbbbb98fd686ccc5b7d6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
