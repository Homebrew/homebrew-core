class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.25.1.tgz"
  sha256 "13b33d661a65926783e7ac3751a5831c0a51484699d2a707f8904565f356ed6a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "416f539e90ac07b149f172bf05daed3add591e5b39d279431ae6926a344fe2ed"
    sha256                               arm64_sequoia: "416f539e90ac07b149f172bf05daed3add591e5b39d279431ae6926a344fe2ed"
    sha256                               arm64_sonoma:  "416f539e90ac07b149f172bf05daed3add591e5b39d279431ae6926a344fe2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "90d16e35ed591f66d2e5f67c46966dc5c1bf7958d5f2fb0cbe593088f7004229"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6521a57db8565a0c947434c88011c7946ac978f3273164fb829666597759b833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d9a39627a3fb89d5db01fcf29174da87f67de0a3c5f9e9bd44070b694d582f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
