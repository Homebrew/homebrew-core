class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.7.7/poco-1.7.7-all.tar.gz"
  sha256 "94672bf834ada03ea83a5f2a7cc3fa07d73d04704997bac1f954cf6c4730fddc"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "069878455ba2f13ff122b60f48f0b58b05dcfe95e66295b05da5204e6686609d" => :sierra
    sha256 "4d7332c458dbfa0d774ea0e6782f9f01c46edc53122d1626de7e5d870f3317cb" => :el_capitan
    sha256 "05f906e0cd61e57f95c3b019b55a826a78610ba53e11270d95bf0dfbd3e1b64c" => :yosemite
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
