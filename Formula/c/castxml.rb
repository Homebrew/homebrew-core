class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "d8498b39b4cf3d57671254056013de177f47fc7a2683f1a53049ab854d85ad55"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "08f2353fdaca10bf594966fb42a276409e7efaeadc7ecf60a1379667b923b9af"
    sha256 cellar: :any,                 arm64_sonoma:  "cf333d88e3baf649c3142fdad533d6e7c71100f53e21ca5186ec59415c48e7fe"
    sha256 cellar: :any,                 arm64_ventura: "80cd21a8ecdac41889bb29bed8e70cdfc05f87314c726d77ed96c3ca0eeb2692"
    sha256 cellar: :any,                 sonoma:        "0ef20ed1736f2609530349fb115998ad435f3513e9344153de92e2e010cb6452"
    sha256 cellar: :any,                 ventura:       "7d9e07e2b0c985652c4b3d7f4ef9625a50dd954d8fb53e37cdbc3d70e338b564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4817790a5db0eba2476afe9c32d45d6beeda66b3a60d7b12462fd33ad065573"
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
