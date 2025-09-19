class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.12.3.tgz"
  sha256 "0beb01fd804b25bbf198af3e18e2fa6bd620cff963ab75decbb0e445a0e5c0c9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "bd3d3c60df1c8baefdc8bd2881d322a83892d141e0919cbad0e658f082eb6f07"
    sha256                               arm64_sequoia: "bd3d3c60df1c8baefdc8bd2881d322a83892d141e0919cbad0e658f082eb6f07"
    sha256                               arm64_sonoma:  "bd3d3c60df1c8baefdc8bd2881d322a83892d141e0919cbad0e658f082eb6f07"
    sha256 cellar: :any_skip_relocation, sonoma:        "4308b634065e07ed0acdb987ea8255319eedcfdaa6a16612b651f695663cde2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80e1d9cf8eee87239e03ecb4f10390270290c6e67d19f29f30fd57410212ce00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d473696633b27dc3aeb9b74c242e1155af6d84b8ea5f47053e0fe7097e9766ea"
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
