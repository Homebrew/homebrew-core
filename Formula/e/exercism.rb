class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.7.tar.gz"
  sha256 "dc8f06d9390a8ff11b24b251644287453e73f0f71eb4277f8fb53dca1825140a"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4094706321a258525f9bdd7d0d6f157fa5b7f99959cbe12bcc9595183d121d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa0e2a9c3b15de521c76b939cc2ba4ccbdcb2491c195e22402dcc30d9f9f7e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa0e2a9c3b15de521c76b939cc2ba4ccbdcb2491c195e22402dcc30d9f9f7e0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa0e2a9c3b15de521c76b939cc2ba4ccbdcb2491c195e22402dcc30d9f9f7e0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e400ddac87b4d522c9555095857f9e76a083279b10034a818a56f6860a5db8b7"
    sha256 cellar: :any_skip_relocation, ventura:       "e400ddac87b4d522c9555095857f9e76a083279b10034a818a56f6860a5db8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19a2bace200bf5ac57ae49ef36e7316a24e2a502944f5704f64bd500486b55c2"
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
