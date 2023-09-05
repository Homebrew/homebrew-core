class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.tuxfamily.org/"
  url "https://download.tuxfamily.org/baller/ballerburg-1.2.1.tar.gz"
  sha256 "3f4ad9465f01c256dd1b37cc62c9fd8cbca372599753dbb21726629f042a6e62"
  license "GPL-3.0-or-later"
  revision 1
  head "https://git.tuxfamily.org/baller/baller.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ballerburg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fdd4855a7c3dc5acf1a3f63f684ef23f55886df256002bd92284608269b6e4c3"
    sha256 cellar: :any,                 arm64_monterey: "41d2f33620f8f0c8b418d7362f40d618785db53d624fb5eec3be48ee0361c8f9"
    sha256 cellar: :any,                 arm64_big_sur:  "e0917508a2b1eb6721bf4694ca269349dc523a210cf8fdcc1395d266742e1f70"
    sha256 cellar: :any,                 ventura:        "a569610cfc27ecc87a0c4455b2693e564c5d0cf08d8c36d6ab4ecb5e419ba018"
    sha256 cellar: :any,                 monterey:       "8c7f3a3a864e9095ba740202e528b73b2e19d604f1e8179b4c09db4aa71be8de"
    sha256 cellar: :any,                 big_sur:        "e8d832e1d5400c66663f8090893073c6c3748b9fb6461b960c227c19f4583649"
    sha256 cellar: :any,                 catalina:       "862a6435cf14376e0c5dd7a12337bd03dc1d5b1d1917dbaaa3a0e704d025929e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44e030751c6003c0267390c81b07a892d9a131f3167f77be138885ad0069bbb5"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
