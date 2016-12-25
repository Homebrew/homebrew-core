class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.1.0.tar.gz"
  sha256 "bcc96aaa609daae4d3f7ab1ee480126709ef4f6a8bf9c85de40aae48e38cce66"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "29026072abd447a7c86c547b4e4336a8b0a6ec32a112e6ef98d06cfc20218d6c" => :sierra
    sha256 "bc24f87088f42931fc88837862243c83effbc76ecb78f0f5ecf47ad797bf8436" => :el_capitan
    sha256 "537597e7723697550b9288de9ec8fb399e956d1a2e1d7924fad8308572dc19cc" => :yosemite
    sha256 "ca0deb4bf0853767c5254ccd040b4fe56ba7b8979d7acc017080cd5deb73ae62" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
