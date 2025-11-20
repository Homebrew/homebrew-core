class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.1.1/qbs-src-3.1.1.tar.gz"
  sha256 "95e8de11cd66710975d4225d35ee01fd43691e4b65609399de367cb8a1df3af9"
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
    sha256 cellar: :any,                 arm64_tahoe:   "db039c21061aab9b2a21c2a7fb7521650536e8a9e4fea80641bb566d4a6a86b3"
    sha256 cellar: :any,                 arm64_sequoia: "6c82107e93d73b2a72cd125968806484ac831ad77c5600886a8e2854a3ce9783"
    sha256 cellar: :any,                 arm64_sonoma:  "cdb657dd6003bd6730e8584b3d6d611d759f8b06d3012d9e9c35cfcef59cc02e"
    sha256 cellar: :any,                 sonoma:        "91b852713a5a31e674c3657dd3ef06e274c937f18a4feae1aaa9dca9991feabd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc1031a9aa3769989ecf2648f0050f66957093d04e21a71b1c5c1dc38d6717be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac7ac0414e853295957695db4ffbd90816513cbda3099aadb6708e2aad1310f3"
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
