class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.13.0.tgz"
  sha256 "1e94ab72fb159549804a6c3f7cd63c823e61db03d27de252f97d57fc0a6b5366"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cda53c42e689959175419221783c0cabc5d547b46e3f32b2f91603f867489b80"
    sha256 cellar: :any,                 arm64_sequoia: "9dea667a13d0c7be9e9ae37941230fdab27c924a68dfe49f382ffd292eda6936"
    sha256 cellar: :any,                 arm64_sonoma:  "9dea667a13d0c7be9e9ae37941230fdab27c924a68dfe49f382ffd292eda6936"
    sha256 cellar: :any,                 sonoma:        "c5d706fdfe3851c6291c5f5e3b1a01bd67e09a963735ba25cc87d2a13cd3a968"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57905dc7a635efa60f98d248e5ca4e723cbb1209bb6d9aa6e98cd5fb136c9aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b941d31207973eebd038449582b2746ce99a1feed4bc8edf193d02fbb464d754"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
