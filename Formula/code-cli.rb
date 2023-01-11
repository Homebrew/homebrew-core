class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.74.3.tar.gz"
  sha256 "f3db2b1132977ddd0309e7c3da5c594a5d77bc423d5e64b3c9900890a43be9ac"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd2b90edffb26b8562428df3616449dfcdca5c02fb0c859b88202c0b8116d024"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b1bdc451d47eaabae7e83a03766f0a79bfa03bddd126a1a3c5bf9cbbb09ac57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bdc268faeea2d6bd21824f296ca37ffc18ca21dfbb0ff956315d40945eb5772"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee51700124588424d87ebe2367ce8f4e02ed7c627ad7312ee07a7763904f01b"
    sha256 cellar: :any_skip_relocation, monterey:       "3cab5777e5c49bca9eda26c4308bd22b2f40ec99512f4476ddb566081fc916ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "e071e61d47e169f36624eeea8aa87c5901d84d5653aa5913fb87e3374968bf29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9884a8387b97187a32ed9ee0c8d67dc3872752919ce6d8d82c2942aa36d295c0"
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
