class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.10.0/qalculate-qt-5.10.0.tar.gz"
  sha256 "961d3e6e1718485d2ed23b7f3d065462eac977a087fd12082edc6627b00f8c50"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "905a016e7290b91393e8ca908ea6f530d95e821225e6074e5600549e1c99a29a"
    sha256 cellar: :any,                 arm64_sequoia: "14b4117a9a26bc2e8be58e10662cab2f74821bbcfcd8a7803147b9e21818ce70"
    sha256 cellar: :any,                 arm64_sonoma:  "3acfb701a3c529a3e77227a745c95efc7d3441126cef72ea31de3855c1473920"
    sha256 cellar: :any,                 sonoma:        "a3ad2048cd6dff0defd061ce38b4eda1b08e9a2e6fb29b930dcc4cbe77df2ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22a695008554c07791020ee845c654ba6700d77ffe0f826b8de56b1598d2f09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8315bf03a7c2b8825646eb35bc946039eb3296a8a64c393e3dfac25a746561"
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
