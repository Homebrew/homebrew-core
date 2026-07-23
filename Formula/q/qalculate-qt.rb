class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.12.0/qalculate-qt-5.12.0.tar.gz"
  sha256 "8eee50aff8c266365d5e455e913133162ea96ae4ce5be5977c3d12fbeaf5d0e4"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9f3ecabdfc78190a3c6f21b298fdc7e9f82123c63a1198accbd319aa22d596c1"
    sha256 cellar: :any, arm64_sequoia: "50338b886798f8af601c9306e47da023d5d3f379781b289085ab910219b26437"
    sha256 cellar: :any, arm64_sonoma:  "08e3782fa43f6d46a89810d14b622980cac552a364a58c93852733457c4f3344"
    sha256 cellar: :any, sonoma:        "0d687f78334fd6e91440de8f00d17c8c1e45f6c8ec46629427d93050f7cd7b11"
    sha256 cellar: :any, arm64_linux:   "c30ed88887c096a04f8a68599c1401cd3cf87fa73e31e7e1f712b87664518d34"
    sha256 cellar: :any, x86_64_linux:  "0aeac7acef5beb4811c7af2de6ff9d26625e2de3cea446312b996a9e523792bf"
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
