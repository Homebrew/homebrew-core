class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib-C++/GeographicLib-2.0.tar.gz"
  sha256 "906b862aa9e988534fd5b8d9f3bae07437e0079a4236e19942ab61fe8c83960b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3fc3f421dddd658cc96b68c967532c25d055b9a859bda415c701955f72d12542"
    sha256 cellar: :any,                 arm64_big_sur:  "e132e08e23c5085c1e19f93031b0cc026865e4982f7f7ddcbf0e119294424c4a"
    sha256 cellar: :any,                 monterey:       "098f8b7de3b85fb22e4d2f576765c6a697d4f7521fb2c3ee08f4ef6c6611fff9"
    sha256 cellar: :any,                 big_sur:        "0557d7dc687a21e488ab5d9312006ab575bc6fe889f4d73a2d7e5fdecb637060"
    sha256 cellar: :any,                 catalina:       "34d13afd308b36029e264f082a65b88cf4deb16ba34b1060f9ed12bc7d3395b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c16104286c395af78eb7ec2c9be9050676bc753815d0b6b83d144a559257920"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
      args << "-DEXAMPLEDIR="
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
