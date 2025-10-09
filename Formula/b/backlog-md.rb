class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.15.1.tgz"
  sha256 "ca2a78f91883b39425dc9f6d458f8f8dcb07aa31917f23884c7986dd9d563b0b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "09a10ec72d260f18b76d4d5317eaa0c83fc11e3e2e9f87693c6061ae99b49a89"
    sha256                               arm64_sequoia: "09a10ec72d260f18b76d4d5317eaa0c83fc11e3e2e9f87693c6061ae99b49a89"
    sha256                               arm64_sonoma:  "09a10ec72d260f18b76d4d5317eaa0c83fc11e3e2e9f87693c6061ae99b49a89"
    sha256 cellar: :any_skip_relocation, sonoma:        "329494a14f72eae74cff2bec7e30ac97eae6e29354ff005ace1c68a2f7b41fc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec59ad0fb385e5bfb4c5985f908ad1c864fbda4b45e4cca35b9f9d8eb372c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5745eb34161fcb29d09b86833b8ccd44ea337aa024b7224aa70569a3607812b4"
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
