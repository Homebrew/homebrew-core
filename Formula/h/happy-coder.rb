class HappyCoder < Formula
  desc "CLI for operating AI coding agents from mobile devices"
  homepage "https://happy.engineering"
  url "https://github.com/slopus/happy-cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "42e1281f806aa2e604d684853213e4936f2424ea220e90f2cd6c06f4f37f297d"
  license "MIT"
  head "https://github.com/slopus/happy-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03313b663fe8310e65192bf523cec55c71aac6c6921a19812e713789647cc11c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03313b663fe8310e65192bf523cec55c71aac6c6921a19812e713789647cc11c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03313b663fe8310e65192bf523cec55c71aac6c6921a19812e713789647cc11c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e961c5aaee5f1b54553a239ec2dee90a4b16942217ce6027d3ee442a904a9f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb9de9d2959ccac07a1d8ec38ea92c54cb850cb98b5da6e038ebaf077a475d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb9de9d2959ccac07a1d8ec38ea92c54cb850cb98b5da6e038ebaf077a475d17"
  end

  depends_on "yarn" => :build
  depends_on "difftastic"
  depends_on "node"
  depends_on "ripgrep"

  def install
    # Remove bundled binary archives before build
    rm_r "tools/archives"

    system "yarn", "install", "--immutable", "--ignore-scripts"
    system "yarn", "build"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Create tools/unpacked with symlinks to Homebrew versions
    unpacked = libexec/"lib/node_modules/happy-coder/tools/unpacked"
    unpacked.mkpath
    unpacked.install_symlink Formula["difftastic"].opt_bin/"difft"
    unpacked.install_symlink Formula["ripgrep"].opt_bin/"rg"
  end

  test do
    output = shell_output("#{bin}/happy doctor")
    assert_match version.to_s, output
    assert_match "Doctor diagnosis complete!", output
  end
end
