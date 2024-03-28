class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.0.0/qalculate-qt-5.0.0.tar.gz"
  sha256 "4143033faba2851de992dc7da96a81362b11a447256b0df7cbc0fbfabbd34408"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2c21823b38ff56ecda1672baa2ff8ea50dd3bd0d27dc50fbaba4a697a810397"
    sha256 cellar: :any,                 arm64_ventura:  "3f7dc83ab226ecda9a69a08784185ff6bbda31b63c57619ed2613fa6b70a4e4a"
    sha256 cellar: :any,                 arm64_monterey: "b997f820b01d1f613d4c5a3e7190fa558930bc8eda59326da356b54c6b4ee5d7"
    sha256 cellar: :any,                 sonoma:         "931a6a0df65579e3039470f6769ed55b8f84213916ee6cf17ed58b2488c12d21"
    sha256 cellar: :any,                 ventura:        "19860d39462acbd77ae2684194cbe2eb1d06aac328314b506d59f8b956a7bc12"
    sha256 cellar: :any,                 monterey:       "970581653625cb862f8ff5d2e43337688cb28e5daf4d13253f6072a96f771e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6041ba2211b4188e2b2bb8afa943b1b16e67b52cfb2ec5e0452ed28eee89d702"
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
