class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "7e01a838877d6fc9faea5a6ad3834351b8e485acc9053bbdf59ce3ab3ce0d3b8"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b311c3642def3e11ae44e4b6b90ee243f00bc59c663c3c6ab9cc1bc43cd9762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b311c3642def3e11ae44e4b6b90ee243f00bc59c663c3c6ab9cc1bc43cd9762"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b311c3642def3e11ae44e4b6b90ee243f00bc59c663c3c6ab9cc1bc43cd9762"
    sha256 cellar: :any_skip_relocation, sonoma:        "18e7eecdb457f42735e41d75c673eae542368dbff1ea53deb02e1b5cdc71da98"
    sha256 cellar: :any_skip_relocation, ventura:       "18e7eecdb457f42735e41d75c673eae542368dbff1ea53deb02e1b5cdc71da98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466a70c1d2431a89d961596adc39ec2a1a99ae149426fe3884d52c44901f6b3a"
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
