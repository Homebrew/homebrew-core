class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.45.2.tgz"
  sha256 "5a3f70780d25bb402af69b6e309ab820e165915bc0d5340a6f61127123c82a0a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6246019dcdb4b7f5ac72533605530af3ce5b2aa6a6108fe12fb344638ac90bd4"
    sha256                               arm64_sequoia: "6246019dcdb4b7f5ac72533605530af3ce5b2aa6a6108fe12fb344638ac90bd4"
    sha256                               arm64_sonoma:  "6246019dcdb4b7f5ac72533605530af3ce5b2aa6a6108fe12fb344638ac90bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "281b6f35e829a30f3642eaf2c9ebccb24e94729d4ed0d9cdd39035e0f82688ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e742a36a1b83f04379986b7e1120375a194106cbefe06cd1e1afff580ecff98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c49bbfab05fa3d4ef8a3866858b3967f943924ebb40837a3d7a80640315b841"
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
