class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.6.1/qbs-src-2.6.1.tar.gz"
  sha256 "9f7f1a1f7daaa4a39fe3604f1851d0e520b576ee7750a7f97bf9401bcb849f2d"
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
    sha256 cellar: :any,                 arm64_sonoma:  "546b89eedb0a9c77b99492f62dd202076d820a57791c5c0838ad05c240a6b409"
    sha256 cellar: :any,                 arm64_ventura: "0064fe9dc16510cd84ff7da779c309296a45b904698231cd0e11309f7aff6f40"
    sha256 cellar: :any,                 sonoma:        "0c1f18f7ef4ecbf92980c755820a9e6007e559f11ab7d0c4bc8848ca185da3ec"
    sha256 cellar: :any,                 ventura:       "a8768d4dc02f5b323d1f3525c6d8f52772217cd47c288b9863248041bd9218d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9223cde738c5a7094813cf1aca6538dd9cd00ff20557f86acef4a46cc3b9f022"
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
