class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.4.0/qbs-src-3.4.0.tar.gz"
  sha256 "4ae86d989d5a80d131051068e37f84932f6094ee8671ec6659110907d9b655ce"
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
    manifest_sha256 "a1f2dc3e3e5dbe9a08a780e131881d67c0def4eb61296252a03d169958cbfd1b"
    sha256 cellar: :any, arm64_golden_gate: "f2b435d1f6381f70de3706bd61342c03b31840076a417b47307a3bf18bb48e79"
    sha256 cellar: :any, arm64_tahoe:       "f4b3d4bddb4790db0284879523472bf1089ee0128ebf4d6affe112c544c82117"
    sha256 cellar: :any, arm64_sequoia:     "5490551c6027eb295956b3ecea9c847e6445a5f9bbc5c616c063ea2f950bfa14"
    sha256 cellar: :any, arm64_linux:       "4b16d0fb7284fa3371d8e3f43e0ae6e1d8c508bacfd1f7bd93bfd3881ee56a9e"
    sha256 cellar: :any, x86_64_linux:      "060bd258966849087106dbeb84c3c4bbed59bf65ec4d9e775711416087e8ea75"
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
