class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9175cac095d98a5ac6d70b8562e322ee37e6708ebfa614da337c7d3c54700ec3"
    sha256 cellar: :any, arm64_sequoia: "7775abec38c073459aecf5f18e62d99042b16f59e6f6987ca0f705c61a93b41b"
    sha256 cellar: :any, arm64_sonoma:  "49cbc13cbd5f6bff42af965a19610e9a9a1ae779960f9fde38a5fb11b4e68616"
    sha256 cellar: :any, sonoma:        "6be9ea478a3615e1dc2a43b12a50d03d2108116cb50f63978548f3fea17406d0"
    sha256 cellar: :any, arm64_linux:   "5c6707cda8a0c7e507c1f0856bb3c3d4b59946aed8593243bb88b2489c495aae"
    sha256 cellar: :any, x86_64_linux:  "88f0a5a5387b0b076e5d83c215a1ef65b880ac1cde286cb17e6d787649298f74"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
