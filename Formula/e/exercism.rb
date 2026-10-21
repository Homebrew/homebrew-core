class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/refs/tags/v3.5.9.tar.gz"
  sha256 "8595fc3e8b0ff3fcff7cc56a67bee58156665e71eee1ff9eace593568ec8debf"
  license "MIT"
  head "https://github.com/exercism/cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd1c5be55e0d9e25bde268f638b40c4004099534e7348e98ba87d8d9892ccf99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd1c5be55e0d9e25bde268f638b40c4004099534e7348e98ba87d8d9892ccf99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd1c5be55e0d9e25bde268f638b40c4004099534e7348e98ba87d8d9892ccf99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1403c120e676f930dcbdef58415ae4bd20d031789990dff90aee7d576c046be"
    sha256 cellar: :any,                 x86_64_linux:      "b2005e31ec7f40dfd1a98170054c71bf04527eea0f02530a9dff366ce274da95"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "exercism/main.go"

    bash_completion.install "shell/exercism_completion.bash" => "exercism"
    zsh_completion.install "shell/exercism_completion.zsh" => "_exercism"
    fish_completion.install "shell/exercism.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
