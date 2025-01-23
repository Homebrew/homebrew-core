class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.5.0/qbs-src-2.5.0.tar.gz"
  sha256 "1801afd4f1fafc3015bd93a60da3896bf211ab4a328cddefde3cd16bafd5a6eb"
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
    sha256 cellar: :any,                 arm64_sonoma:  "5fb9a815d1e001831db5ff60098f0ff661f4b71f3e975acb08dcf59d3726dc55"
    sha256 cellar: :any,                 arm64_ventura: "ab77553e4154463eb7c06ed42c18e4fcf59d12685722143128fb0e7e336bb5f9"
    sha256 cellar: :any,                 sonoma:        "2bf04cb0a924019586cdde2c5cfe5de73b41269dfb6db62277857894b10d7fbd"
    sha256 cellar: :any,                 ventura:       "1e0df2143512ec1c0604181b69692edd458e146587e48485eaaa33a458a46aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781a640cada110eb658a14edbc58cd1cfe8bfc7344ce884fce87ea7d12252673"
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
