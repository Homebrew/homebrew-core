class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.4.0/qalculate-qt-5.4.0.tar.gz"
  sha256 "a97d1813bd68562465657136ebe7c3fb925d442efadc5aa14ac3806c152d2816"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6b50afdc2f02ca675fa76d2454502efc30628b2f007debacf5b2fcbc5476dbce"
    sha256 cellar: :any,                 arm64_ventura: "181792531b47243e84b0fea5ec13d8ba63998e944962672b9c558f3386e18514"
    sha256 cellar: :any,                 sonoma:        "59e33fc72bb520ea8ca22a6958d46ab727144bc8dcbe14a36126caadd36afad3"
    sha256 cellar: :any,                 ventura:       "a632fa9a12cd594646d4b60dff2d4683241adf7a4aa1c794bb1d0e0999dc2b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0560b558736c380de57779ba37dec31767efad265630f0274957a79bb1891798"
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
