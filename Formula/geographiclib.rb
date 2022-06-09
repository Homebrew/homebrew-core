class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib-C++/GeographicLib-2.1.tar.gz"
  sha256 "7a4bdbcfe76c7848960f177b597187e16abd30140da067ff5221cee900cfc029"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1847acdb8e1dcd484433846bfdef9c2ea01a43d716526f3045dc9ffa4974363b"
    sha256 cellar: :any,                 arm64_big_sur:  "03d3cb7002fb7362f57230fecbb6be39514f8702ff8bc794898b2e45a62646b9"
    sha256 cellar: :any,                 monterey:       "2e9321667acad0b9cb8e0d69c1362af5ae2d09d2165bdf558122eb5c45439905"
    sha256 cellar: :any,                 big_sur:        "649e300eff8b33e8c906408a4f6e6c90cc6796b8668a61f14e52061570daf93e"
    sha256 cellar: :any,                 catalina:       "ec865d543602fe431f68ebcba8eb88fd9a771ec76035538fcbd7bd134e0936e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0ab365d86ca984339d3a1fba30cff6bf1f9e68933c209f2c1941ede52fe0956"
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
