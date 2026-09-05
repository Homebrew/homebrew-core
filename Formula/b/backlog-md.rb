class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.51.0.tgz"
  sha256 "20d5a58f4b9b7140fecea94ad901b04bf1aaa0f837a21fc0ca6b803d7072e2f3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256                               arm64_sequoia: "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256                               arm64_sonoma:  "c4269429bf3cef81808b244bd34ecfbd39d2e6a91828ee9d41d55660248ec2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941efc9cf1652377a40e0538afa956858ebe708f7841199d414e8377e9279ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6223840ec01ab7d2622c8978de7e1e817fcc2cdefc740dfd510b5a8d8a762f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end
