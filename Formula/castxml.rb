class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.5.tar.gz"
  sha256 "007f6d073165e150df0e40e1ec331f6f94304684af9eed3b0e5dabaebcfb1197"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7710e2667427b667c27907905a50084a3ff9466e308dd12f4825983ebd3eb0a6"
    sha256 cellar: :any,                 arm64_big_sur:  "6e21cb15925d1398805313b022281cdf61bac37d06b17768dbb736952c213813"
    sha256 cellar: :any,                 monterey:       "c12e6bf4714e1f208d6c2467ecc48c2931dd7fa2b7b74971a487ab328ce72c94"
    sha256 cellar: :any,                 big_sur:        "60dfbc11e9850fe6df0f13925173db6b6d8a349eac98c997ea70bfd28d888e33"
    sha256 cellar: :any,                 catalina:       "d46e70cbcd7bdd674c3f0595f4eace13286bdca0167a5dc11e92a8587077faef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89162f0cf120b5d29671c08176e408a0a7e6f62862ad7b56b8a782f2710228e0"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
