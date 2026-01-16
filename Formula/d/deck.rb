class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "3619c5077338b3aa199a746ab244ff24ee150fb115f71d6e94fdb9c26fcdb209"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f519097b7b3ccd18dbe4162cf4a97cf2db90791fd2d87277e4e3ab3b5a143a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f519097b7b3ccd18dbe4162cf4a97cf2db90791fd2d87277e4e3ab3b5a143a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f519097b7b3ccd18dbe4162cf4a97cf2db90791fd2d87277e4e3ab3b5a143a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf04d283611071f281fa40d290226415f3eeec080f907920f6617acf47465a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74af4a7f55c63705d3ca20fb99fb37bd007f6f8031428ffa7420cf0c1b97144f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bedf8cbe3c8e7a1884f45f5892817cedd44197b829da627dc7566a1123638bb7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
