class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  # Remove `stable` block when patch is no longer needed
  stable do
    url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.4.tar.gz"
    sha256 "86d02c7ed743122ce8c6d888c643da92fb7515da04577a933d33180fb7731872"

    # Support LLVM 18
    patch do
      url "https://github.com/CastXML/CastXML/commit/64bc54080f43da003045a557232a029e985704ed.patch?full_index=1"
      sha256 "0236e003ffaae18eecbe2f059335fb3be23db1366a22f2c2c2cf9f6dbc4d0cfd"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9cf45433f1399455744592c7ab7b6ce29b038051a251c68fd79806b2cdd2207e"
    sha256 cellar: :any,                 arm64_ventura:  "a31e8699f8cb453192db7cc6969b2d2f4d98f60b97150386370121f9c14e5cfb"
    sha256 cellar: :any,                 arm64_monterey: "4900e8a2517b3d9d69de4e9218b7016e414e95b40c28a2c5ea3484d915ec5f4a"
    sha256 cellar: :any,                 sonoma:         "24690f8cd7a4c5534e707e54e5321e55a4f89e78d520331119dbf3db08b359e0"
    sha256 cellar: :any,                 ventura:        "92b89640718e7f0bc64869a58e609fcd96626a5127851fa098aba3cb88baf83a"
    sha256 cellar: :any,                 monterey:       "0d2e9928a653fe2e0ec96e77ff78440a0b5b15f175b539d9677a4c73785de10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201d4d3b45a74903b75c6487846da96efaaa227f9790353049525772db93b8e1"
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
