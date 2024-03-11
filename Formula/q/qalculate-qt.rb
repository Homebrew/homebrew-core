class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.0.0/qalculate-qt-5.0.0.tar.gz"
  sha256 "4143033faba2851de992dc7da96a81362b11a447256b0df7cbc0fbfabbd34408"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d0386df8c7c5ecf28e4387505878c9daa63786f44ff473a7d090456edb37414"
    sha256 cellar: :any,                 arm64_ventura:  "7fee478b64c0b5d5668204de4448162e52bac3f871ff646f82c4fe7185f3b181"
    sha256 cellar: :any,                 arm64_monterey: "408a7c0cc1055fa2bd9465805a72341bcad7b346d52289bd27b3822d3ff1ae15"
    sha256 cellar: :any,                 sonoma:         "ed68cee845c3553d5a281404f12dd4613fd97590422c3a82c568c480c01c96f5"
    sha256 cellar: :any,                 ventura:        "31d2f6f6aefd47bf56bb3ef4ddfa3947afa3ba2d81048d141b9e67315594d53a"
    sha256 cellar: :any,                 monterey:       "09996cdb9d080787095f24b6f74a418b5c7292a691c0bc971e88150e644bbbbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59d248381341b06de88f5b41ec812269ec7dc3615feaa390b13b217c3d23d2c"
  end

  depends_on "pkg-config" => :build
  depends_on "libqalculate"
  depends_on "qt"

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
