class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.6.1.tar.gz"
  sha256 "7a2e5ae99c66b5b44e682f261248cd874fdd7554f4a24fc31d09ac5b6dcde7e5"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cbde8d480daa6f0a465e6b8c4eac0f7483bd70e2d82780e60a8cc1809cb9043a"
    sha256 cellar: :any,                 arm64_monterey: "8ab4dbf83a416c2a7695ff2ded7ae47c5f69c8cb07558943e37d6f8461c59f73"
    sha256 cellar: :any,                 arm64_big_sur:  "50dbd4f801190597c0064f74a175fb30773458fc677e27922f0f927f49db0242"
    sha256 cellar: :any,                 ventura:        "df294343a004fbf98ec397b86c08a1b2a35146e8149c554898ed99eaefb45ec8"
    sha256 cellar: :any,                 monterey:       "83cb5e3f65e4284ccb946552e6b39ab9c8ff7e4ca37326fbf8737932664611a3"
    sha256 cellar: :any,                 big_sur:        "caf1d2d1f7be99a825368d6129b66e8f468d70468851cb0d1330700ce8ba211c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4186634e02f1efc9f98477ab7d9868c05f277ff584df3b155bab5d7befdfa186"
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
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
