class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.9.0/qalculate-qt-5.9.0.tar.gz"
  sha256 "c018e8ccc4c48c5c831d28c32b960f77de1c7e0e8cb6e26e0b9a2cccc91e5ee3"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68951fa9b696f107a1bb8cb603031ae7e1ea90accd7d04ac0d50952ace5078ba"
    sha256 cellar: :any,                 arm64_sequoia: "05d3f2d36d4c785d678f7b0a46f11f60350797d9f17ced407f255d9db46ac591"
    sha256 cellar: :any,                 arm64_sonoma:  "153aea0658a4d7e14c108ce6b71f43e30b3c78ee087c6d36abb18ee50d262f8b"
    sha256 cellar: :any,                 sonoma:        "c0aca1b086f02bdf72478865882b1ec7ac1f00f2554d31c386d41c6cf926a797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ff58539bbe16e17dc7eacfbed3eb44f73b333a15776d1eda92485004471a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc30f8723c18ee04a1556e209a0cfeebc7262c0342654c791d610cc7ea0d68db"
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
