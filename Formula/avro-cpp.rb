class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/cpp/avro-cpp-1.8.2.tar.gz"
  sha256 "5328b913882ee5339112fa0178756789f164c9c5162e1c83437a20ee162a3aab"

  bottle do
    cellar :any
    sha256 "a8cec4c5be2fa818b383f6d4ffc757be0a95ff38c4d758e7c85239affa98a90a" => :sierra
    sha256 "238e5f3ebfee52d2e8822de253c93e04441909f140c13bb007277b1fd7acf721" => :el_capitan
    sha256 "ced89ca959d6e9531033b8257176b381a31a3c8cf2a6cefb02df48e1655500ce" => :yosemite
    sha256 "42eb7e8e11cd12a7411ca50e690975563d49d283ad7e17302c71bf0ae92d8471" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
