class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/2.2.1/qbs-src-2.2.1.tar.gz"
  sha256 "84dad32ff12fda91d4a57c637c86200cdedc7fa56e04daf1c544908ffdb6a2a6"
  license :cannot_represent
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bcbaaf8f97889190995ceafcfcaba4e12abf80d279a1450b78dd50d659401d4"
    sha256 cellar: :any,                 arm64_ventura:  "afde3c6fd1e7a445a6cfd25b45c7bed73491ceb3a0b8b5105c7e97bd5d2e28af"
    sha256 cellar: :any,                 arm64_monterey: "8feba916b1b98252b0d94feb35010e9d099c630bff1d4f076e397ba77875bcc1"
    sha256 cellar: :any,                 sonoma:         "8930a6fb92006898c356686a91f30a18bf211bd6e324d39ed61481380738de00"
    sha256 cellar: :any,                 ventura:        "03724426646d6483a2874dde764b52a28f3a46f477619ff8d0a609f2f036f864"
    sha256 cellar: :any,                 monterey:       "72aded6a2b0ce1cca126a61d6990d44e3211fe514b4cb28e922c4a17f746484a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91164bc000c950ab18c631d6b6ca0669a9f5e8653c0111e62809f179c40cd1df"
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
