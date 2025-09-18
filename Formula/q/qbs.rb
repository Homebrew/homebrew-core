class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.0.3/qbs-src-3.0.3.tar.gz"
  sha256 "5ea02139263ec4dbf947d18f4a73ccc41f691ec43c5914a6a6b089d9713ec0dc"
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
    sha256 cellar: :any,                 arm64_sequoia: "de23c0f6e1eb0db96bb05300afac1a38edad7ea59860fa94632b8c1380bbcdbc"
    sha256 cellar: :any,                 arm64_sonoma:  "73ed45e1ae002ab27f86d004f7003825478b59726d758996214c24147ce2c387"
    sha256 cellar: :any,                 arm64_ventura: "c04e7d54e0414f6fdea083c401f21fe4d7d7d7a5b00fa163f9180f23a3743972"
    sha256 cellar: :any,                 sonoma:        "e78f408be5a3413cdc154e7a25d00dce596c9eba58cf5188993b16b73e96425b"
    sha256 cellar: :any,                 ventura:       "027a239f45c910ddae143ede13b6117667122eba2979b75c929afbbfcbecda99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a453229b6e2a073c41494aca5077a42207b3a37c1e895187e6e97a9b90465d"
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
