class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  license "Apache-2.0"
  revision 2
  head "https://github.com/CastXML/castxml.git", branch: "master"

  stable do
    url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.7.0.tar.gz"
    sha256 "e70728229db5444384befcba9681a01497e9a19e35166ce1ffef3b5cbc8eeefe"

    # Backport for LLVM 23. Local file to remove README.rst changes
    # https://github.com/CastXML/CastXML/commit/315fbacc4e4b9c7ea21d25ad489a90b73a526326
    patch do
      file "Patches/castxml/315fbacc4e4b9c7ea21d25ad489a90b73a526326.diff"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "15354394376999d885ad4613c53e2067949ebe943e84cea05a5bbf923ceef5b2"
    sha256 cellar: :any, arm64_tahoe:       "b314ee3515fa47020f68d782a51d86c2ea5693ffa321de28ef04c4542f78ea11"
    sha256 cellar: :any, arm64_sequoia:     "54caafe93e26de2dd56d6b4933f6252d83a2fdf5707181b265e51eb66a60cbc3"
    sha256 cellar: :any, arm64_sonoma:      "f289845c384e94c6816951b3c2e3e389142e3f4875b7d224d8d5af36ff52915c"
    sha256 cellar: :any, sonoma:            "6c8cd79db94b7e87b76d4b33566a30c4321eca470b03adbd1338036ee045e57a"
    sha256 cellar: :any, arm64_linux:       "32f44b6a2ea6c0bd1cf5304e93aa054f6ab1cb60d600200d7671cc82d68be1ce"
    sha256 cellar: :any, x86_64_linux:      "9f858a4677682b804335b6218db77406c4f7ee97b222da050e8cd6315f08a758"
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
