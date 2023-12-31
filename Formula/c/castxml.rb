class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "9bb108de1b3348a257be5b08a9f8418f89fdcd4af2e6ee271d68b0203ac75d5e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "99d0482384e3c87e41fa92652f2190bc9e06e40bbfb061694d9207f32e420667"
    sha256 cellar: :any,                 arm64_ventura:  "21b5ee0d2a20fc87f46d3791548f936c1ccf16388146099cd6205302045bf65d"
    sha256 cellar: :any,                 arm64_monterey: "b8f9b7a12887e08ebb1ffcc8ca5d1b48b8821f364ce655420e06b5817ec732af"
    sha256 cellar: :any,                 sonoma:         "b273934bf727a940a803b79856f38df47f2889b29f8dd422a8cf1c9bddd3c5bb"
    sha256 cellar: :any,                 ventura:        "38be4529d66d27332eea64da709d5bed9b7a750d88225e84bd39641ccd0086e1"
    sha256 cellar: :any,                 monterey:       "2096d5b4a7c1416473da5df322b4383dc16abc07bfa630f604ea099d2c2c13eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3359434dec38a29c16138a96c392479cfae63b2b73879fc80aaeecf73ddafcec"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
