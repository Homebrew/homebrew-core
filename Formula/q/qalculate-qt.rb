class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.5.1/qalculate-qt-5.5.1.tar.gz"
  sha256 "2d01841f7a7703417c6c251bcd6bcda81db0bf7d5c32827b7a8b396d572af843"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "b06ff9fe513cb5cf5001cd191b09c8c216b4ecc0fcb72811758e7887cc5504cc"
    sha256 cellar: :any,                 arm64_ventura: "0a09e028d074e3e8e8f7b83b43db1f03b2ae21d59a97e12cb09e22ff53849100"
    sha256 cellar: :any,                 sonoma:        "a612516358a27b4d6c6d44d539b1c46b06d13de1143105b199e56964963e5ffd"
    sha256 cellar: :any,                 ventura:       "9c64e3a28a9b2fa83c4ba77f289ad8cf163acab3d8b982e67b7cf2333a7da06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05413f45291372343722733bc6c2d4d8c1b1d9b77d34a7695d6f5c683bbb9fbb"
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
