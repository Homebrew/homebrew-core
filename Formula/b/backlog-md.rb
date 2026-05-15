class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.45.1.tgz"
  sha256 "29a7abe94cf9fb194d850408a12566507f5b4d676a79920fee44c53d511345e1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d11498cdb6d914130cc180630f8fb9bbbc97c7469160cc473ae65ea169a070f5"
    sha256                               arm64_sequoia: "d11498cdb6d914130cc180630f8fb9bbbc97c7469160cc473ae65ea169a070f5"
    sha256                               arm64_sonoma:  "d11498cdb6d914130cc180630f8fb9bbbc97c7469160cc473ae65ea169a070f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8240aa15017a5d8cb012ece9fba444c45a53b771a26c1fb83c5ea32466b0151"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f2f3cb28a79965ddf5a0c724bac80ca913b28dc32b5d08b4a8ac6762d6132ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a408a6b8c2e68eb73f12d82c1b069a31cdf570de4b07f62d4081145151fbcff"
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
