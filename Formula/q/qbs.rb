class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.3.1/qbs-src-3.3.1.tar.gz"
  sha256 "5d8b58a5fb60c83a311331aa10d90536e4d4cb28d5078d3554edd807a5af9a8f"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "838a4406b33002e3804c3f20db1086f76720aabd4eeda74cc5d8152438bc665c"
    sha256 cellar: :any, arm64_sequoia: "9bb476024a72a928d06b3a5ab65d6336b526deb6234c457a4ecd4d03f42aa9d5"
    sha256 cellar: :any, arm64_sonoma:  "1fc0947f54c0eaea8219d1e554dd1c0b958668ac0f2c680c4e3558c39014b21d"
    sha256 cellar: :any, sonoma:        "590b4e6d8cdaabab0fd5756138a2e02b5b38a728fb51f127e24a913eca10c88b"
    sha256 cellar: :any, arm64_linux:   "591a5ca69efe36cfe6968d2f1630b3bf5d7c00c3d7df2397bb8d1988171b4e57"
    sha256 cellar: :any, x86_64_linux:  "a7ce49526306e415aef25a6123bf86e10af80f06a5879add78ba672bf31eb160"
  end

  depends_on "cmake" => :build
  depends_on "qt5compat"
  depends_on "qtbase"

  def install
    args = %w[
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~QBS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    QBS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end
