class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.13.0/qalculate-qt-5.13.0.tar.gz"
  sha256 "b6cc1fcf51b2e1fec917d06d7ead608f45cb1f090527ef2aaa4706f0c4247b5f"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c8201eb801250bc7650fde43eaf45e4f6b74b2d5e9f875aec5f5edf9dc2ab5b5"
    sha256 cellar: :any, arm64_tahoe:       "c8201eb801250bc7650fde43eaf45e4f6b74b2d5e9f875aec5f5edf9dc2ab5b5"
    sha256 cellar: :any, arm64_sequoia:     "d19947c29f17e1783e187b95a10c980fd44cdb699ee2b5e57746cb4befe9f110"
    sha256 cellar: :any, arm64_linux:       "d703658dac8c80132d633068fbd0d6005460cf11dae3ee771b1f3c1b30e5c10d"
    sha256 cellar: :any, x86_64_linux:      "980f4f7a9e7850c2e1178e1073cfe1a3e4f22d98759bc75c4035e93fbbc6756c"
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
    system formula_opt_bin("qtbase")/"qmake", "qalculate-qt.pro"
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
