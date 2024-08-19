class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.2.0/qalculate-qt-5.2.0.tar.gz"
  sha256 "6daef548376d1a941515f3ee5c268ec97a64668474ff6c31e02890eee12f2b75"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a7e63fd639f49eb31601f6c2eea7e8429418d2b43d86f70dc6f39fd1e14055a8"
    sha256 cellar: :any,                 arm64_ventura:  "f671fe56040a83b515f0a65b47b2fafbd5d497749b0d7b26637bc710f00d9a40"
    sha256 cellar: :any,                 arm64_monterey: "d5837f81d2d6ad0b890d6fec89c8a148b074eb0620bd84bce51f173e344d9d7d"
    sha256 cellar: :any,                 sonoma:         "88c910592227c1a2b78ea726d66633ba8946d6f33aff5b817ba33a54a5f8b295"
    sha256 cellar: :any,                 ventura:        "8ceccec8881002a8d86867ff05af3054e46999316d71647c93202a6f62d9f8f7"
    sha256 cellar: :any,                 monterey:       "aa72351f073595ef463d56b91ac5042761b9cbc43769e03775c151bd816d5109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5715165b6ed170d9c4aad20084f426266e0aeb65fa3171d182f358f41be18d4"
  end

  depends_on "pkg-config" => :build

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
