class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.4.2/qbs-src-2.4.2.tar.gz"
  sha256 "0e158433c57c8089e1bc15497eb121d3010f6bdbf5210c1f5cff5018da0e86d1"
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
    sha256 cellar: :any,                 arm64_sonoma:  "26987b0e86070deca3db4e55df1a8b418ef7050c4c2bdeb158efb9976d31f703"
    sha256 cellar: :any,                 arm64_ventura: "6f0c88768def1926f8e026c4ffd759d5957074a4b9f0568a086383bfc7dba4cd"
    sha256 cellar: :any,                 sonoma:        "e60a59eb73bc02915636c432a153f8814b97f04e56c7a6ae47ba72ab9cce8945"
    sha256 cellar: :any,                 ventura:       "9a2f889778f555a90dd79b66e838b7fdfaebaa32ae772668efdf18368bd13a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2be0ba3a5ffb4e999c405f68956cfc6aaa1934f24e986d81b4549738bdd0d2f"
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

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end
