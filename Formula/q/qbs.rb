class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.1.1/qbs-src-2.1.1.tar.gz"
  sha256 "3acd5704494777f185ba64a47adfb8a690086f007ad0e3d296f32bcb21f72843"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bd26b54138f0844297fe4faa612c849998757e6481fc482615e5e37418ad16e"
    sha256 cellar: :any,                 arm64_monterey: "6ce2e97cc1b0f854d8e3119cd8cbb95a7b0fabb2af54ce07214d59a62af96d1c"
    sha256 cellar: :any,                 arm64_big_sur:  "d0b7fc357c48560363169859eb4a07017eaed5b97e898a4e8f240de0ef0a8304"
    sha256                               ventura:        "9461960e30bc33315effdbefeeddf7a81352219d79ffad785d476c5608cf00f8"
    sha256                               monterey:       "3b5f802b5fa49c37260f1cdde577dd1484a950cb6f047a8dbc9936d682fbe309"
    sha256                               big_sur:        "2ca002c8da1869a11eba474fc5a0cda83892e00d6c14c0037810d2b6b528ba5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ccad2090a8acc3a41dffa34844ae22d293fbdae3bf02d9134317d957e75c566"
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
