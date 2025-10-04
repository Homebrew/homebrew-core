class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.14.5.tgz"
  sha256 "aca667670e3c69e7999a0e4be80783c786fbef2867c7a2bd3975d6fba71e3178"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7e882b90a2ad04bd5fb20aa6bc1d5b8b9b0dbbc4c6ae45b645c2fa4e4b47bfbc"
    sha256                               arm64_sequoia: "7e882b90a2ad04bd5fb20aa6bc1d5b8b9b0dbbc4c6ae45b645c2fa4e4b47bfbc"
    sha256                               arm64_sonoma:  "7e882b90a2ad04bd5fb20aa6bc1d5b8b9b0dbbc4c6ae45b645c2fa4e4b47bfbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a2fab83c378b4369900fb71eee8ea858cafdae3f592e725f210f880671c53d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49d505b993f4e76b31b6ee84b58b670c63f357c3f05e9cc85e99083daaad9192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfafe8ae5349b21e8fdc8a958b97df6299ad1192942aa1ca95e6b8a481aaf09"
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
