class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.4.tar.gz"
  sha256 "58dcd1a62552466b6fa3d3ad62747b1cfeafae5fca3b511c08f5efa9af22539c"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edbed801d51e954a07e8361b1f046e7debe55a8d1f3395cb1b76119c322e6843"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edbed801d51e954a07e8361b1f046e7debe55a8d1f3395cb1b76119c322e6843"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edbed801d51e954a07e8361b1f046e7debe55a8d1f3395cb1b76119c322e6843"
    sha256 cellar: :any_skip_relocation, sonoma:        "73e1f0791210f733ad58582e961694a6e48073fc3c05211fec65f187d446f1a8"
    sha256 cellar: :any_skip_relocation, ventura:       "73e1f0791210f733ad58582e961694a6e48073fc3c05211fec65f187d446f1a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db0470e98aa26162d4a8c02de1c650665b43b9331eac64e2a98cfa495993701"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash" => "exercism"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
