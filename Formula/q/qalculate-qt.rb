class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.11.0/qalculate-qt-5.11.0.tar.gz"
  sha256 "c6bf9831bc6c2d43077fd8a1167c3c47154edecf9cc91c84bf2c8fe7f1b7f620"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c3c0f4e9bbcaeddcb4c31cb9fc251f8dd69d8c4a055384e3a0e1cba04e4f899"
    sha256 cellar: :any,                 arm64_sequoia: "12ad9d586b37be15cdc11d3ab4c133eb3a1d28f7c8385ad6b45f2c24f2244911"
    sha256 cellar: :any,                 arm64_sonoma:  "251759ceb371536339f33a3123263c996f90705e8d44a8edfda3f993c556c46a"
    sha256 cellar: :any,                 sonoma:        "d45b3df3297e583e53865f0b9c8fe2da24f3d72c5197413ef96aa19094971a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e781b41fc0786ee7cd282fe06d5114a457af1e16c25664d6e70d9f02a9c7f772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d997ca60aade57e693ebce7eac8824c29c785c960b957bd4a6d9d9086369052"
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
