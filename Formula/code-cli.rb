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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a9ddb3aa0e0acc4e35f169bb229849bd4849e98356a69fa0c2e80316c95b9e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "431636837e15d5039f98bc92530d30be7afd2e2d94f5af0dcbd155de0cc43829"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69795c5cf591e932f794c3f4119ef321e094c3d6bd02ef18d966c425ca3aef7"
    sha256 cellar: :any_skip_relocation, ventura:        "161197f36f21e2cd5c2d186626cc03d44b6f87aa3aaf5901fc794d72ed13b906"
    sha256 cellar: :any_skip_relocation, monterey:       "50c6eddb8c27da0150fb7d2bd2f3556ff3385a82a827a35395bae8c38220d6e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "eceb3d4048f7208c377bdd35a2dc0cda9bf8f0dc1369c6b9e750387de86dabc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a32939dc78d1be5e826a0ff522586adfee6cdc8cc5fcfd7c0ca58b749b58a07d"
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
