class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-qt/releases/download/v5.1.0/qalculate-qt-5.1.0.tar.gz"
  sha256 "b6571fc85bde7f2b1422f215a5c4176bc1013726e2971d4c27770078be659a7b"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4e6fdf6a19b94fcfcdb5323153d9d91f98e492bccfb911eae95829a090a1e90"
    sha256 cellar: :any,                 arm64_ventura:  "8454ca3e6ba1f7431251aff4b366fd117f7d0e25a9d34bbb9a17235b1154e83e"
    sha256 cellar: :any,                 arm64_monterey: "4c516b46259cd1db7df29d42801a806797a1d26ca7989d59d8ceef9afaa6b009"
    sha256 cellar: :any,                 sonoma:         "d32ada1fdd78334acfed407902d25496fc3392b18383a216529cc7a68b49c48e"
    sha256 cellar: :any,                 ventura:        "edcee51dd3a5f2e4c3e4f4653c7b2c4e833d578e7359b0d6e65eeda8abc8a4c7"
    sha256 cellar: :any,                 monterey:       "a475a46ca546e84e3bd7dee4e03824b806952e372d9fbb1b0bff7022ff4d300f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca45004d08ab0aded020bd169e6866cb2edf9cefb345144e0fd1b488756e19f"
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
