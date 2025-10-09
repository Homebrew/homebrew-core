class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.7.0/qalculate-qt-5.7.0.tar.gz"
  sha256 "76e03b976a7b1347a6e8779b6be83ea053ab74e8ddeafb0aa62d20b3fadc0b9c"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "26b8843f8e3bc933466a7ca78ca60beeb498452e736fbd09b6ed27f65c5ad94a"
    sha256 cellar: :any,                 arm64_sequoia: "3a5903ad430375c98dd363bd2eae18a1faf0ecdd491c3171a9be258de61d10b1"
    sha256 cellar: :any,                 arm64_sonoma:  "47e659391bea63d7646e9e3a2fb03f41f4fedcbfdbeb484e6a99c8adbfefd9ac"
    sha256 cellar: :any,                 sonoma:        "13f441fb6a0373fd027167ce0e30b9f860a8bf9755c8a37f057119ea33842d75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f64db8f68961a6a9dcbd460484d7458e1b6f3bc109bc797000a0a3deaaf1bf"
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "libqalculate"
  depends_on "qtbase"

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

  def install
    system Formula["qtbase"].bin/"qmake", "qalculate-qt.pro"
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
