class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.0/poco-1.9.0-all.tar.gz"
  sha256 "028de410fc78d5f9b1ff400e93ec3d59b9e55a0cbbf0d8fec04636882b72ea45"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "238ceca104aa473ec3b0bbb0d9e3f096867dbfb9768f17fe2aed0b1d7bf91c2c" => :high_sierra
    sha256 "1647c805242706a0e8487e7f540ede8043e0b51ab617f83317b7d1e0be1cca6e" => :sierra
    sha256 "accada3a83a5be692617b17480aabbf2073a32e8b4a3f38df35f45c19d37830c" => :el_capitan
  end

  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"
    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
