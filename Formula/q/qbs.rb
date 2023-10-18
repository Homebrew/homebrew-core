class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.1.2/qbs-src-2.1.2.tar.gz"
  sha256 "465d398ba3ac2bf157c4c32118e7ea55759050550e5e2babff091b000f2c27c9"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be4694984587a6fad7374e154ee6167e6b753f503ae2ffe3ee4972a66ecc9f59"
    sha256 cellar: :any,                 arm64_ventura:  "6e76bfb4ccb12ea1cc007c3f17e140e302e481534839eefbaaca5fcefcc2f2f5"
    sha256 cellar: :any,                 arm64_monterey: "3824c645bc95f25a4c1fea7977baa533bffe4fc7f90e58a85d345834484d1bce"
    sha256 cellar: :any,                 sonoma:         "dbaebb37b8063c5e8125d0d28b3328568bbcdb8597debb177ad0816ed9d0d792"
    sha256 cellar: :any,                 ventura:        "23f7f58fde3602fd5e70407f910120d5f5a364c07b6a78154888f6ac9e78c84e"
    sha256 cellar: :any,                 monterey:       "49a288c7c858a00dd3bfcff6fb4ee0b65fe4dfe3193f921e8f251f5e942150c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dac28065d65e8efd0f04a08f057165f75e05c2a0de3cfc7fd5acdecffe7f197"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  fails_with gcc: "5"

  def install
    qt = Formula["qt"].opt_prefix
    system "cmake", ".", "-DQt6_DIR=#{qt}/lib/cmake/Qt6", "-DQBS_ENABLE_RPATH=NO",
                         *std_cmake_args
    system "cmake", "--build", "."
    system "cmake", "--install", "."
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
