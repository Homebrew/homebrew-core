class CodeCli < Formula
  desc "Command-line interface built-in Visual Studio Code"
  homepage "https://github.com/microsoft/vscode"
  url "https://github.com/microsoft/vscode/archive/refs/tags/1.74.1.tar.gz"
  sha256 "ba730c6af17aee820cf99d83df9adf3c253a5a2229f6b0124aff000f2343d325"
  license "MIT"
  head "https://github.com/microsoft/vscode.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb3546414865927d4e0cdea74c961818d2dded38a0b7e5ecdadf0840420142b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087140dcda8710aa6f06665279263bbb42b1e1aac348108c9c156e0a2202bf14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57787df0637a861893a6e7c31979cd8ce1aa3e952b0e846ab8264dc6c85927e9"
    sha256 cellar: :any_skip_relocation, ventura:        "bca95deb4dee80570ab887d45f0f04affadf39c03807f0a7f0d5d55e8b2ed1c2"
    sha256 cellar: :any_skip_relocation, monterey:       "32bbcf69bc24bf34a95404325d1d44cc19089d896d31ede853a80b4ec23b64f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "41444fb2d659f4c5ec979844e135004bdbbe423660d1d7e0f2d1eb93be7e4d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92850d0d363e194cf3797d62eb49283f5f1230a6288316de08dd07cf63482d22"
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
