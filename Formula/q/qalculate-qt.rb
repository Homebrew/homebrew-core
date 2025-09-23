class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.7.0/qalculate-qt-5.7.0.tar.gz"
  sha256 "76e03b976a7b1347a6e8779b6be83ea053ab74e8ddeafb0aa62d20b3fadc0b9c"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "ecbc0902df9615ab02cc14c7821b763df4cd91815c320790e2d37227dea33ab6"
    sha256 cellar: :any,                 arm64_ventura: "f2cad1739fd3afa7ccd0d56ba2309f528505de2bdc97120dbe11870d82fe9b78"
    sha256 cellar: :any,                 sonoma:        "6f457c9182a94f0b80ec5b59f735c88e9e7f58de4af63d52a6ea535be56dbcff"
    sha256 cellar: :any,                 ventura:       "9c10be6c17d81fd8f881e87e0b4119f115895c310cfeb26fd0e4e99314312fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63e9383503ff926b1bb7c0646624d8589eab2530eb83e52f5a496d5ad52305d2"
  end

  depends_on "pkgconf" => :build

  depends_on "libqalculate"
  depends_on "qt"

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

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
