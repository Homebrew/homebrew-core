class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "f79ad5cfaca794ef21439f5b3b9c196074febc55605624cc4cc4c973c10c589d"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e05a72c32c108ebb2ffecd867d81b0d6116d389e0ad411ae74d7b130572a15d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e05a72c32c108ebb2ffecd867d81b0d6116d389e0ad411ae74d7b130572a15d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e05a72c32c108ebb2ffecd867d81b0d6116d389e0ad411ae74d7b130572a15d"
    sha256 cellar: :any_skip_relocation, sonoma:        "26ee99039c774094e39d20d6054d5bd7513f10d89be4590ae9838001870576ae"
    sha256 cellar: :any_skip_relocation, ventura:       "26ee99039c774094e39d20d6054d5bd7513f10d89be4590ae9838001870576ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c9cf023f91a032386239d7773de841367993543b7b7745d7ee6154b16b8deb5"
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
