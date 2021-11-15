class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fa748f84d30c7bc75ec371159abcc48fb4fab2d20d3e5df0d3223579766c8c90"
    sha256 cellar: :any,                 arm64_big_sur:  "e712a34c2decedba055e39541fbb78b872ea9e178bed59bf640bcc8e64475280"
    sha256 cellar: :any,                 monterey:       "f12e79add745f67aa47850cffe84e35da4749fd991ffddce0cd4aa34fd57fdb8"
    sha256 cellar: :any,                 big_sur:        "b77980ffac7f53ee65fa687673a6121af17ae85abb8f0011043b3be6a45c9aa8"
    sha256 cellar: :any,                 catalina:       "60b53a12e893def4e42d85bfa935dd3b7a2fa6f1bb1d452d13ea5c043f2a5e85"
    sha256 cellar: :any,                 mojave:         "2f604161ef01f1c7d81aad9857bc3b31e74ab726200e0d899dd079b968115e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b1902621363c9de9de7a05cf4b0c093cba38b91dc369e2cb21aa477463220a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
