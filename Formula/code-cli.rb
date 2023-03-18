class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.76.2.tar.gz"
  sha256 "f68b35c96f85a30e5f69e5119a183113433c2a47c08a2d639329e4c01cf0d7f4"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70059943855aface8090186d27b2dd9a168eee83d54a8a8b2b22859f312b5ec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdf86712fad84ba8ea85ab85012a20f614034ff8875d829d1cf047c29b3069ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae18da81e2f066d58031250d08a07f6ce9bc1e580ad02aa524114f46b15ad148"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5db6d1ba710518f155d63f5cb4e2c1e962f8176856b183c85ba8917d5cf351"
    sha256 cellar: :any_skip_relocation, monterey:       "b64f1ccc5819f8ca9d1b167af30506952d274cfa9fcc1eefb06e128b7faab615"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbfb59813744a3cf8cdb3e83776026daf44f31cba4f1429524ed0f5a257f8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93eb1e835bec4da6d3038b82355829c74da44fce65862e330c77d0517d4780b"
  end

  depends_on "rust" => :build

  conflicts_with cask: "visual-studio-code"

  def install
    ENV["VSCODE_CLI_NAME_LONG"] = "Code OSS"
    ENV["VSCODE_CLI_VERSION"] = version

    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "Successfully removed all unused servers",
      shell_output("#{bin}/code tunnel prune")
    assert_match version.to_s, shell_output("#{bin}/code --version")
  end
end
