class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e70728229db5444384befcba9681a01497e9a19e35166ce1ffef3b5cbc8eeefe"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dac8eb2ebe8f34868e8f9e4851507ec1b36d2617be04670149d09df4ba7e8a77"
    sha256 cellar: :any,                 arm64_sequoia: "1d8e8c80d511b4caf120b190aaec38308805f46d12d11f8a25e63823e38ffb51"
    sha256 cellar: :any,                 arm64_sonoma:  "3dc6b1a96297fecf5c67837c55edf34d81900f8e9cecbc33ba9839a3dbfff643"
    sha256 cellar: :any,                 sonoma:        "196b284a940cb82eeaaef68c69816322d3780fd0ccff403f238064dc08e79073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3582afd45fd31626602e6e800110bc4433c7aaee98552d590bea3d19b739aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1746325a50cb2b71178fd06d9759de65091313333efe38bca72faff558deff9"
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
