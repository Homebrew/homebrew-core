class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.2.tar.gz"
  sha256 "88a69e931dfd081fce2cbbefac2d912497a3d46154cdf86653eb1fd2cb1628ad"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "bbb6e6eb302d60608fabc7937f317fe604a18acb56e440172b9bd9ec05c7e98a" => :big_sur
    sha256 "c65e8a6a8f4c7d1428525423f30aad4c523e73f6d36a1e7d908848b6821df94c" => :arm64_big_sur
    sha256 "aa5aa9e65ec5c47228e25e4b93345cc3e2198578eaca3614a468b9a3b485a5cc" => :catalina
    sha256 "6e6b3353e5700078c4395ec23876c7cd015883dfa618e92a5347bd45c8e865da" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
