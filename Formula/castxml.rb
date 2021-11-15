class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.4.tar.gz"
  sha256 "e7343edf262b291a9a3d702dbfa6d660e8ed81170454eab6af10a6dbf8c8141d"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d76eb4f4e3cce08d062334f2c99f1cba63a3f831857ad00899ac7f5d82ccb2d7"
    sha256 cellar: :any,                 arm64_big_sur:  "90aa62c5229d1084a1f197090b3c44b9cd85abddaf1695e2fecce2a2720b3f12"
    sha256 cellar: :any,                 monterey:       "d8f8b6e5b027ae5707cdd74aba6f194babf02413b2251dbbab747426fd21ccac"
    sha256 cellar: :any,                 big_sur:        "edd91bafec4e441ccbbcacd735d204873db448e36a2c45e84342c7e8f33a21d1"
    sha256 cellar: :any,                 catalina:       "f44f3a928ad632cc5dd323d1122b597fd93562f83ebad2fbe4663764ad449726"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fad7d88989008f812bc20583e05db10f9489e8fd9315afc03a22c9f0f9f0fc"
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
