class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.50.1.tgz"
  sha256 "ec23dec5dc94e8b60c759345e10284730a7574e7c386b665e5bd0a4369f48a1d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "050c292ff53471f66a90990c7bdd582fc1c3524753f3d336d7d5471d36b64b36"
    sha256                               arm64_sequoia: "050c292ff53471f66a90990c7bdd582fc1c3524753f3d336d7d5471d36b64b36"
    sha256                               arm64_sonoma:  "050c292ff53471f66a90990c7bdd582fc1c3524753f3d336d7d5471d36b64b36"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb7451616e115ac8c4cc34dae7a5d9bf98c475a8ce3c918e3ebef4c980d65bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33dd45f20cdefa4c816d4e9ea19540cbe56e0147de94d42ec49ff67465950344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88caff3397ba8d88d012f33e70c5e1d90bffd46dcb187a383ffa0d768497550c"
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
