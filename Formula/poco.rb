class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.8.0/poco-1.8.0-all.tar.gz"
  sha256 "c0f2ca3fbbb701bfaa55796d7b6ef35127cb27d4333c2e75074c601276371fc0"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "5cd62e42f9ad7474eec3e19f23e931d68d22f3223a40270c293489e4df1e273f" => :high_sierra
    sha256 "7169cfe55d2a2f5c0a3bf84f0ea7563669e99c086295cf11ce8f8fa037de1c60" => :sierra
    sha256 "e7d22874f68e594a3a3bba87e5b22376ef53e2da3c374ae1e50ed0b367d919f3" => :el_capitan
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
