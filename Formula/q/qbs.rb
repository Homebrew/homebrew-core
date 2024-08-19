class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.4.1/qbs-src-2.4.1.tar.gz"
  sha256 "9ad8f4a58d76e86f78da65d5ae016e930ea977f95b933672267a451828019e7e"
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
    sha256 cellar: :any,                 arm64_sonoma:   "99051b9e58c66c232030e0bf6c4b014b8a260319937c51a2564018635945b151"
    sha256 cellar: :any,                 arm64_ventura:  "5e8581e006e77174acc714e9c1be9fb98fe15373fed998fad6c13739b69a041a"
    sha256 cellar: :any,                 arm64_monterey: "14d67a7cba22056c22b3075a07b4090a356d0985bc0374a296bf7c3989948aa4"
    sha256 cellar: :any,                 sonoma:         "fd7567ab9780718e57a84351da61f4241b47e193e3361a0bf7ff977a2ea888a8"
    sha256 cellar: :any,                 ventura:        "537b9f4cbd539e75224883f6f01eb4e7d82274f62ac64d2498826f179e78a3ee"
    sha256 cellar: :any,                 monterey:       "ac196d23e8539d33c4bca00e3f2c1b11f33dccec4c4b7af408b8000fbd0f6e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d1857a48dc38bf1255744876583d07bb9293d8e573e95d4cb40d574162850b"
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
