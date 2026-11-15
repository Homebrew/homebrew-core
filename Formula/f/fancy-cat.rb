class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2e471b389c63a27a140c6a67b890d0900d3bc616254ac35f4fd7e0f8e8660061"
    sha256 cellar: :any, arm64_tahoe:       "a4fe6f58c2b8faf8b246d3112f147dcf77713c729dc0c9b448e3508f8c7185cd"
    sha256 cellar: :any, arm64_sequoia:     "d229b5f23ba927d7ff5e7b72f7188259bcd03faa407519e942287c68de394550"
    sha256 cellar: :any, arm64_linux:       "c8e2a8046253a20976040b8af7c052f1b0b1024b135c537d3b04a213295a2df5"
    sha256 cellar: :any, x86_64_linux:      "8b4c5d55067c67eab224b7df3a5802fd26f4a1beb42f5308731fcc326e2dc48f"
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
