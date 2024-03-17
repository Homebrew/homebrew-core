class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.2.2/qbs-src-2.2.2.tar.gz"
  sha256 "93e0938fbef2f60f175ae4070fbec5066744f61424ef80f9e65b54f1be8615b4"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "53ce70872ea8c7731c7f961e5c54162855df53fe1f4adbd8c70604decc9b8a6c"
    sha256 cellar: :any,                 arm64_ventura:  "74ff72313fa43ac6e33b2639e1d59e7f3a04e9726f3f8234447aa24a8530984c"
    sha256 cellar: :any,                 arm64_monterey: "2496922db293b15fcd9d187b8eb1bb9977d3df3970e2fddebaef4fe18514c155"
    sha256 cellar: :any,                 sonoma:         "47990c489562f449555bd9fc060e64b4feced3e871066f12aa954ab98559f531"
    sha256 cellar: :any,                 ventura:        "952e1d9937897883e3951baa58fc4bd462f7db8aac9c951f5e89632a86111aff"
    sha256 cellar: :any,                 monterey:       "0eb41d474c61a0e009e70732e2a7919029de1d4783dcb5bac95ca9501bfe693f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7407842e538149fe1a5e13a74b916c5b23bfe9ff213b468f717b7a2b9d8cbcba"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  fails_with gcc: "5"

  # Fix for Xcode 15.3, patch can be removed
  # for 2.3 release: https://bugreports.qt.io/browse/QBS-1786
  patch do
    url "https://code.qt.io/cgit/qbs/qbs.git/patch/?id=5c88b6b11b762cf5861c9d1570df4f1f050c826e"
    sha256 "bf49f5519122b37c1632ff465ea7df086cc618769e000811fb1f9002e77daed6"
  end

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
