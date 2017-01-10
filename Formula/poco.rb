class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.7/poco-1.7.7-all.tar.gz"
  sha256 "94672bf834ada03ea83a5f2a7cc3fa07d73d04704997bac1f954cf6c4730fddc"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e110d8f5783c123958953cae06e39e1181acbc3e305d1dadaa62b9fb7188bb8a" => :sierra
    sha256 "90637ba91f14b1a46c9d705485ce99089cf58bf8ac61c122d1e74407380e1cd0" => :el_capitan
    sha256 "80cc2ab2e5ab671ff444f2c420096f2f0e08a4ac60229e4d28af117c0e7bf921" => :yosemite
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
