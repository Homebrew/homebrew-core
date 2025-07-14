class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.6.0/qalculate-qt-5.6.0.tar.gz"
  sha256 "9255bb18f96cb305a9d087ef2129ffa76fa4e906e5638d4b83a918a623cdd82e"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "5d52b8f8485d2422e32350047685b124d6c45308c80e5187a1660382326cb4db"
    sha256 cellar: :any,                 arm64_ventura: "b759fd4b8682b42a2a17b781aa2bdb9c823b62fb0311c0a535349176781689d8"
    sha256 cellar: :any,                 sonoma:        "8683955f068a2d2a3db0956bbd104304c0a98864c55f6aa990b24abe8ba41e20"
    sha256 cellar: :any,                 ventura:       "158121e5363bbecff6ee0ace2bfb59ec1e424d6b7a5492c1cf3180be4d8881e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fad016a9049262b3d9678e7798d1046e3bbfe502e0db98f70f536ca13407c35"
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
