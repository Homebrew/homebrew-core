class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.0.2.tar.gz"
  sha256 "43865604debd06686ac4d8d0783976c4e10dd519ccd5c94e1b53878ec6178a59"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
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
