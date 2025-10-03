class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.14.4.tgz"
  sha256 "df584cb6ddefd69d290641119406b82d67df9e57e35c62670831a0fbf2de5195"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "37e588d6bcd7bd8c23760056ac483ed2df8cf7c69260ec84047c1e71df0b3240"
    sha256                               arm64_sequoia: "37e588d6bcd7bd8c23760056ac483ed2df8cf7c69260ec84047c1e71df0b3240"
    sha256                               arm64_sonoma:  "37e588d6bcd7bd8c23760056ac483ed2df8cf7c69260ec84047c1e71df0b3240"
    sha256 cellar: :any_skip_relocation, sonoma:        "458a61d9a6dd4842dc78967ba534644e94f4d4909531e85490d0e77530b5c958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f9cad2b217c0fd3801a959db4784e6a4964b46ea1c43256cd0152092dba541b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67696b9bc6677eb9d9c82d6483a4bf5ac2115dddc5bdf65bb87c7f75198920fd"
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
