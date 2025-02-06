class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.5.1/qbs-src-2.5.1.tar.gz"
  sha256 "1a13d0d1d1349a83d386ffbe155325603f849c2ad8b148b4aa7f7dfccf506576"
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
    sha256 cellar: :any,                 arm64_sonoma:  "eea32037b439e083b77ad5ab7bf432377509109c01bf83048be9d5fbc3017b06"
    sha256 cellar: :any,                 arm64_ventura: "38ea1b19469dc7d00a63ea7ee25b1c9c7e7d9e148a2f08c3e8a96c661fbd7978"
    sha256 cellar: :any,                 sonoma:        "85b8fd07fe6c14739ba23038cd97f79aa6dec68e6a3a400a9580c699dcb9d3de"
    sha256 cellar: :any,                 ventura:       "a5d95d351b47662f1338467d2b650a5e0511d0f91304ea4c2d1c53fcd30c3fe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a5531d639d29e1d52a0cc75c510dd1527d67d77d2eb233be9f9c4be7de06a2e"
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    qt_dir = Formula["qt"].opt_lib/"cmake/Qt6"

    args = %W[
      -DQt6_DIR=#{qt_dir}
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

    (testpath/"test.qbs").write <<~EOS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    EOS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end
