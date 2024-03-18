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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "1aef0597a90185bab8945e7795e53344c7a2360b54ce0ad2966b37aa049e64a3"
    sha256 cellar: :any,                 arm64_ventura:  "607e0b4a326ae60c9b3deaa87c9a20aae1f592f3bdb82136faa9d848eb32bd52"
    sha256 cellar: :any,                 arm64_monterey: "85e2cecfc063abe38c921395a827f25ffd436083cef9455ffae9bf0092c4bb0a"
    sha256 cellar: :any,                 sonoma:         "d09d190826553ad2ba36d407154bc79aa1593ce86b223f8a1121245d4742dfa7"
    sha256 cellar: :any,                 ventura:        "0b66a3c79ddc14ff5c14e9691135fd8d693929aef786e7ba78effc4968301dc6"
    sha256 cellar: :any,                 monterey:       "523bc05a90b98567b3c7efc5f20a083a26605e4aa30616379de68edb00bf662e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d340fdd7c8117cae9e91fe50bd86a4c5835d5407f5eb6c1b0f1aa519610bd664"
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
