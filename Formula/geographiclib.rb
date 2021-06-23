class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.52.tar.gz"
  sha256 "5d4145cd16ebf51a2ff97c9244330a340787d131165cfd150e4b2840c0e8ac2b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "9c9fcfba39ac076e5681018ffd222742f6d813e156f44389bbffae7f54a9c602"
    sha256 cellar: :any, big_sur:       "330b858cbb533864caa4324b2385399e49807ce93671be290ec6b16c09c874d6"
    sha256 cellar: :any, catalina:      "a8d601014c3a569b8b0ebb48e0f92055c57c2f915354a1e4030a7cda4a1afcfe"
    sha256 cellar: :any, mojave:        "145e83f5076511c2d86ec4d8ff4de7536f909411d70b8ba81fa976f7c756d11d"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      on_macos do
        args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
      end
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
