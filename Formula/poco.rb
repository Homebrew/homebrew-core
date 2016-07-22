class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "http://pocoproject.org/"
  url "http://pocoproject.org/releases/poco-1.7.4/poco-1.7.4-all.tar.gz"
  sha256 "2935d9c5e805d90d2d4c12d8c45330f0558fb531e6947f5b4bf0748016e6959b"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c01ed1ca68597f7c589f72f7f0ed8cc88a402032dcbf29bc1c487ff930f3e1f9" => :el_capitan
    sha256 "ec8251d0b48421096da72bb4c2bbe9c2fea300d07c7a4eea906c4d637c52b64d" => :yosemite
    sha256 "ce5330607a1fdad9b79434f0990ad953da56acbdd16f9ad88c0b8fc8dcdc17bd" => :mavericks
  end

  option :cxx11
  option :universal
  option "with-static", "Build static libraries (instead of shared)"

  depends_on "openssl"
  depends_on "cmake" => :build

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args
    args << "-DENABLE_DATA_MYSQL=OFF" << "-DENABLE_DATA_ODBC=OFF"

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DPOCO_STATIC=ON" if build.with? "static"

    mkdir "macbuild" do
      system "cmake", buildpath, *args
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
