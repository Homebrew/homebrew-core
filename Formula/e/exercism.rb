class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.8.tar.gz"
  sha256 "386cee0117c42a0ead45b6f636f96c2fc20cc5f64f802fcda93c7a0778330f3c"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aaf7754295ebfad0033c5dda54b07308c495fc073e1ea7add2a98bfb510a5b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aaf7754295ebfad0033c5dda54b07308c495fc073e1ea7add2a98bfb510a5b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aaf7754295ebfad0033c5dda54b07308c495fc073e1ea7add2a98bfb510a5b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6a436c7f77575d6085829ddb221b002b42d984cb6e40b8f1d19517dc2d6313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7836067011aa064f86a81a59f943c872e4b0d42b144f0176ef95a7f5a80ba73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cdfccf8375cf192881c31449e775e4dcb4ff07cf8e00752f484c323ee086eb2"
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
