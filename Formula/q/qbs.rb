class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.3.1/qbs-src-2.3.1.tar.gz"
  sha256 "ca61c6cd259c3cd5e2f4d6ca8b9d648880ea9de419cd69e99f571eeab0e5f9ea"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50c1c163dcd97e9a8024fa1af9fcd91fb33b74c437a74f40a58e0e5750b2ece8"
    sha256 cellar: :any,                 arm64_ventura:  "ab46ad225032f0d005dbd551cb82af020e812d87161f10ee90d368176edebdea"
    sha256 cellar: :any,                 arm64_monterey: "24d5caeab647517ca275766ada8bdd274b525e1ab27211e2054dd5f45a83c576"
    sha256 cellar: :any,                 sonoma:         "d02af707897379ac783855cf33cbf4c8c7a12bd6b097f14faf97779e725f455f"
    sha256 cellar: :any,                 ventura:        "2358fd3f9e43ae711e97371664b113c6eb99c0473a2f0908600ae4bbd1c230aa"
    sha256 cellar: :any,                 monterey:       "b27c01317b54ac4c98b1bca4cb4db7f01bf1253f9707f2140870b268a06fd8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f321840a3b37463a6a525a40691e1ac5004a719c7389f6bd14ccf56184493b86"
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
