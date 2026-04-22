class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.2.0/qbs-src-3.2.0.tar.gz"
  sha256 "245724231b9e24e79b3f7363358082d5dd33f69e698500514ddd4ac99deb001c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "5bb7a1ef21c2a4b2b4f6f4b70862b999b592ad501d417b528b4b08ad02bbf182"
    sha256 cellar: :any,                 arm64_sequoia: "da5830922773e53a28a63f1f3105fa2dbd7344d8bf1d39815a76c7a1feea8324"
    sha256 cellar: :any,                 arm64_sonoma:  "084979bdc676ec9418eb71e9a038bebed38cc6e554017a91acf6428fb8acb00a"
    sha256 cellar: :any,                 sonoma:        "5d8d90c2097f2cbe8b19a7f8f431754c75b90e6b0c8db8e82e2b4cdb18c904aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a481a69ebf870e36441d4c8f43268dd52f76ed62e0756cbc63a821b23aeedd2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b9e0ec528efa0631a93a0de0ea7abf32a18243aaf7d355b6c64171fea7eac4e"
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
