class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.8.2/qalculate-qt-5.8.2.tar.gz"
  sha256 "ebf547910ce5c5624b8d158873ff88c4379288cc687993e50655f9f7ead171ae"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b56c88a0f7ce91274cff9184de1c602710122ca79d9f6c0d8169f96cf1dc5a74"
    sha256 cellar: :any,                 arm64_sequoia: "2d785c0960737200d9ddad9c5c47a091fbafc859cb01a2352216b1a769f421f1"
    sha256 cellar: :any,                 arm64_sonoma:  "45277ba986814980a6a1e0788d2b0b3174121fd8ce1172eae7e7c69c21250e9c"
    sha256 cellar: :any,                 sonoma:        "d672d5c1b0f064245f07fa0a9a2671d9c7a7f24f8f1d7fe1f983bbc067314f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ac3485b2ab79a014f4671a08d575fc86d2528444686f5a7045b46753e84ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d63973b163ebe486bf4d1a4ac4da371f24af5d8e084f4ece33049b4cb9201b7"
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
