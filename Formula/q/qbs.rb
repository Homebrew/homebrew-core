class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.0.1/qbs-src-3.0.1.tar.gz"
  sha256 "154838d4a0647ebe9fab80bad9a8f6057c08f5723b6b06638b37cfd96bfa70be"
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
    sha256 cellar: :any,                 arm64_sonoma:  "fe328df1d6c32474f2388970d86261de29fe4f22a4a5e03bc52f32d876721e4a"
    sha256 cellar: :any,                 arm64_ventura: "c30ae5a40dc5bf110e56975c64f37d775998a6dd9e253d541874eb9b9113c0a8"
    sha256 cellar: :any,                 sonoma:        "2048bc6b964670cfd8822ddc9d6d1572212e958de0512b9a0324f76e9d3d94d2"
    sha256 cellar: :any,                 ventura:       "436a54b50d1649b28949259740708ca3d06c28e074e9739b76ea56e316ac85f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0d1e3c2b56eb01630d127f612e6f037883bf9a9c7e4bf34d479feb33c77e757"
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
