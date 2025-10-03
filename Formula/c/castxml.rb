class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "df954886464fe624887411e5f4e2a7db00da3d64a48f142d3aff973e2097e2d6"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "93ed94817a78b0a29ce51bc14c0fd172cf21c5f7a2532342c3311931947ffd2a"
    sha256 cellar: :any,                 arm64_sequoia: "2e6fee1a97c17d39ac0dbafa497d83e27a3c817d16fcc89ee399953d437022e4"
    sha256 cellar: :any,                 arm64_sonoma:  "583761b0bfb7e507d771a614e6e53fedb81c402e457553657a2cfc157cd52e22"
    sha256 cellar: :any,                 arm64_ventura: "624ab7d9058b3422afe1836930f639330fd4528195d32a8158201cbb85710571"
    sha256 cellar: :any,                 sonoma:        "dc702848dffb57aaaecd4342651467aa4485c2586fa7298b83481528634e151a"
    sha256 cellar: :any,                 ventura:       "5c08e0f22751ca1313864edd717e4b60fd65fefb805f6e4dae5c88e91482faad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56da3651a01eeb3be02ed9b65649553a58152744f0f9cbd6be2ec7adbbe6970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590839164290bc19e3405d79ebc3ddeaab5f2a1cf65a289d4ec7dfbe8f48906b"
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
