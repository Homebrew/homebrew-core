class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af2ac3c1a1d2ed45f3ce53332717889c365953face8be5586ec15cd900fe70d8"
    sha256 cellar: :any, arm64_tahoe:       "a815a7b85a17e52a4468b59879d971b609aa8582f80ad866b52c02b4cc5ecee0"
    sha256 cellar: :any, arm64_sequoia:     "88b784ae234af70cbf384586887d29f72bc3a03977ca5fba8693e7eddb385fa2"
    sha256 cellar: :any, arm64_linux:       "5e0d6b6a52a82495949ee600964fc4d08e42db1a244a36eab69b54f68342904d"
    sha256 cellar: :any, x86_64_linux:      "bf703f8c8ddec2d018df64a904f8ef5276f0a50efcbe67fb4ef0dcc7bb46d892"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end
