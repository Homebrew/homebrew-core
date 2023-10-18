class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v4.8.1/qalculate-qt-4.8.1.tar.gz"
  sha256 "34977c8d02d47831c21a9a25ef967d8c5eefe630ec10f86347a7c598891300d5"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b02b129b6d22082775052dfc6893f937748e0f70c21275a035e42e7f7e5817c"
    sha256 cellar: :any,                 arm64_ventura:  "7e0ab81a6d899a73123d89c84ed9ff3caf8a2975ee4fd5724e9ae3245afca824"
    sha256 cellar: :any,                 arm64_monterey: "19268f4d6b7b1ade02cb1c76be39a81e0a9963b2388dd9d1215ae715c8aa093e"
    sha256 cellar: :any,                 arm64_big_sur:  "5c11dd083c9fef85eb3e1f976260f3483c3b43ea509b203009f01d56a320da85"
    sha256 cellar: :any,                 sonoma:         "564d8e0b7d7376524c091af852bbd8257ade7e1736796ff73ff793ae23ad9efd"
    sha256 cellar: :any,                 ventura:        "8603ac4f1fd33b4fd812072592cca84d5f655603e3c4f4b778c808ef149d25e2"
    sha256 cellar: :any,                 monterey:       "23e0e3b8c9414885342d6c21d7d297cab1e7ca311cddd9eceb28cadccbd63c52"
    sha256 cellar: :any,                 big_sur:        "d1b1411ef55a8bb1ad7dee7a8629214ceb56ee0283ad4936a77cb9b3801939f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c7d8ddd88aea32ff54f071731601012a8abf26ae883eea47a36058073eaa943"
  end

  depends_on "pkg-config" => :build
  depends_on "libqalculate"
  depends_on "qt"

  def install
    system Formula["qt"].bin/"qmake", "qalculate-qt.pro"
    system "make"
    if OS.mac?
      prefix.install "qalculate-qt.app"
      bin.install_symlink prefix/"qalculate-qt.app/Contents/MacOS/qalculate-qt" => "qalculate-qt"
    else
      bin.install "qalculate-qt"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match version.to_s, shell_output("#{bin}/qalculate-qt -v")
  end
end
