class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.3.0/qbs-src-2.3.0.tar.gz"
  sha256 "e7fa44fb36d705ab40f34c24e71bb32beef1210eab2d50bf6f2318a195780826"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fe72372cca32dd0980d302dd28c9eac06aa9e5076d8f6398096d4b73d7270031"
    sha256 cellar: :any,                 arm64_ventura:  "220aa1a8fe0fce5658bdd22da1f6954b3dace0692f8bbd15369fcd29b5085da6"
    sha256 cellar: :any,                 arm64_monterey: "bc3c2880c4b56c044661a8a1092a34592a5e990e337c4295ea3f2490f16c4eb1"
    sha256 cellar: :any,                 sonoma:         "8a857e65cad5c7559f4ade5c245ecb6d81a3ade3c7765855064bee5c7725cb21"
    sha256 cellar: :any,                 ventura:        "cd43eef6a8894a14b9d4eb5e369178adf32793e29988018c486913773d876dc8"
    sha256 cellar: :any,                 monterey:       "69aa33e80ad176172fa87345e3e1d99f65c2eeaf48f6adb17e97c00281f1ff98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5c4996c292c21a166838665e69a696aae8671211ae6c41fd85e42ce4ffc46b"
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

    system "#{bin}/qbs", "run", "-f", "test.qbs"
  end
end
