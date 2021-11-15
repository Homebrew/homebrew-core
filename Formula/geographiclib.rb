class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.52.tar.gz"
  sha256 "5d4145cd16ebf51a2ff97c9244330a340787d131165cfd150e4b2840c0e8ac2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "109df3bbbe080ac511135624045a1e36e3a4f8173480257adea9f9e3a5e4779e"
    sha256 cellar: :any,                 arm64_big_sur:  "302202edfb516879e561d78a6cf81a3476aba292f1a6cf23bb272c9a60bc301c"
    sha256 cellar: :any,                 monterey:       "40d853915374106cd7eb9966128519dd6fee630a30d43910f5bcafcb6a4dbb84"
    sha256 cellar: :any,                 big_sur:        "13facfd20eec2fe0a6ad291a0090a4e66b38e74830306b69cca5ac54674c0072"
    sha256 cellar: :any,                 catalina:       "beeca9653f64dc20bdd907fdeae179d53c9b1cf58590b452f5f02f1d70a7905b"
    sha256 cellar: :any,                 mojave:         "c10d4bb46beafe818efa240b7dd7916e0dc2a9567dcef0a26823e564e1e679b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2338e72cf9eb6bb5a7a382857d89dd32cf29ba46a69d10093dfbbe503d6bbe9"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
