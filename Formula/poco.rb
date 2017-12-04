class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.8.0.1/poco-1.8.0.1-all.tar.gz"
  sha256 "cb891540b44b74e844fd0787c796f2699a894dba690329660e29b57efb8f80dd"

  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "5154731a48afc8b970d0dc52e9272836252b51266765477c24230985599126e9" => :high_sierra
    sha256 "1ea293049af7dc129c8c71bb1b56b7371980d2aa40e5399bccefd5b13a368b36" => :sierra
    sha256 "f749b99a69824b8733d709af6d64b0d440ff93cab67e2927bf840c439c6af85f" => :el_capitan
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
