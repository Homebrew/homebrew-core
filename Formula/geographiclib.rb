class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.52.tar.gz"
  sha256 "5d4145cd16ebf51a2ff97c9244330a340787d131165cfd150e4b2840c0e8ac2b"
  license "MIT"

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
