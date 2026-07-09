class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.3.0/qbs-src-3.3.0.tar.gz"
  sha256 "da836cb4c17d7bdbaf615d750f6795c8d0a65e532e7acdc8159ea61f2252a340"
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
    sha256 cellar: :any, arm64_tahoe:   "391496d72943f0d25e3c4ef607acb94e99410edc772caec7f854dc24d8eb2a87"
    sha256 cellar: :any, arm64_sequoia: "32b1b8b859da434b2a8569cb587d168b8cf1695f0bbeb771ab84778809570181"
    sha256 cellar: :any, arm64_sonoma:  "36c76583c3716a672d92a088b5e64cb0f36d9aad4d280530a75ce2b4f7511282"
    sha256 cellar: :any, sonoma:        "207db6349c34e349f8ea4ec914cabefd5779816965f7fa840c38d8475d9d28ef"
    sha256 cellar: :any, arm64_linux:   "20b6c02f75ece1c42ef63fdb3811dbd733c8bc6cabad15f4d4a7fc5922f46fc4"
    sha256 cellar: :any, x86_64_linux:  "f230b41d255a55b47d37d190e76328612fb491a5727270f87503af63967e659f"
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
