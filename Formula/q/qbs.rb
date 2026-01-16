class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.1.2/qbs-src-3.1.2.tar.gz"
  sha256 "cb0a70eb33bee5a0122df3e6856b1b98d9b00c6f175f55cbb3442bbc9cc2cd6f"
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
    sha256 cellar: :any,                 arm64_tahoe:   "4d1a72bd117603ce416b493189fbcd3e52b4192d781d57dc4034c95e2c8f6725"
    sha256 cellar: :any,                 arm64_sequoia: "dc5d07540a9e8f7f8d67f595f9239caceebe7de679dc9b4cd026cce4ba7dbabe"
    sha256 cellar: :any,                 arm64_sonoma:  "761ffdd3713a9edffa055eff52065931ab3fd24f416a2ed962f3f13629322b67"
    sha256 cellar: :any,                 sonoma:        "c807a83befa12ef13afbc83bca67d643f95f3b374ec38b324f99fd0d31d6675e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b55f674fc0f3cc17d3b6972974d9a796857e2983e5128ab4d4e161add8774158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4b061b7637c7ed483ae5211520f5befefe973dbf7079d05ddc3542e7a3018f4"
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
