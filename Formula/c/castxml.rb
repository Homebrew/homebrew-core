class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "fc5b49f802b67f98ecea10564bc171c660020836a48cecefc416681a2d2e1d3d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81fba162f54969e92f8b6e80e1c25f8883b6c577af305bec352cfe160ca6fe1e"
    sha256 cellar: :any,                 arm64_sonoma:  "f3df454737770552357bfc15b5184b83f995b6eebec8670d200250b626ae2125"
    sha256 cellar: :any,                 arm64_ventura: "ba53c6ba447c654f0bdf437c776556d36410ff148c956438dfeda34c6f70fed9"
    sha256 cellar: :any,                 sonoma:        "5d39704e7e6792b2f433184eb3c69697f69bd8f1307f3ed00e1d7f3265a074f7"
    sha256 cellar: :any,                 ventura:       "d8d9635e8f3cd6d01c59d85d64c49c02b818400a1c22437d82c7bc9779363452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49df8d03d192b404f5be478204549916b1bb9e9496075d1515c2c3376b10c0c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c773dc8de63b455db2dc6f4dd5c3a28cb6042fa82adb8c1282b1fbfbdf815413"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        return 0;
      }
    CPP
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
