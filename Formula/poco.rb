class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.3/poco-1.9.3-all.tar.gz"
  sha256 "583c464cb2a85a1b0d1bded22875a929eabca54b1575124b114dc4f7e573aa68"
  revision 1
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "b8938eb20ed962a8f8b7222c0250d16392793ebd2f74a6fe23027f20e2a9f0ed" => :mojave
    sha256 "1ef5e8720ffac82cfe0a8af98977a8d8ab63f157e17b2e499ad36c6e56d5e2d5" => :high_sierra
    sha256 "7f4d42ffd2cb13ff0172d8f438b9f770d1bfea75a004baa3031991d0e1a56767" => :sierra
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
