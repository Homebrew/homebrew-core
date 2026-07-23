class GitIgnore < Formula
  desc "List, fetch and generate .gitignore templates"
  homepage "https://github.com/sondr3/git-ignore"
  url "https://github.com/sondr3/git-ignore/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "58b2ae7c5fdc057d6935ee411c4a8225151b7ea2368c863d9b21bf4ccafb11a5"
  license "GPL-3.0-or-later"
  head "https://github.com/sondr3/git-ignore.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daab0c3b00b1314130ec974b9e4ff30622dcbbe324d07b45f05045bd87020061"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad525846ff5cfe8b0f8b0d62740c48b7e028f18e0724f423122ace0b7f5a7c96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b805a468776ad33db601c77afac29b5de4eb20225479102914ea1447269633c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e287d25a1321140ae5bb04247d8c9d66c612bd2d924fc1a7bf35a5b20e42503e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74cdcc6265ecd3014caf6e9d06a3581b7d02b2e1eb1aeb19577917dadadfe0bd"
    sha256 cellar: :any_skip_relocation, ventura:       "5f40874c4f120468776f62a856d1e3b19214417b665d7518af3c87cc4562df1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcbf4de3e675c9c457757851101f6f863e8ca63d1807d86ecf5e73326b397330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74eded3d0a43226202ee0c8ccbf9fc56e5c73ec31d73968d395c6bf5b7df4c9"
  end

  depends_on "rust" => :build

  conflicts_with "git-extras", because: "both install a `git-ignore` binary"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"git-ignore", "completion")
    man1.install "target/assets/git-ignore.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-ignore --version")

    assert_match "rust", shell_output("#{bin}/git-ignore --list")

    system bin/"git-ignore", "init"
    assert_path_exists testpath/".config/git-ignore/config.toml"

    assert_match "No templates defined", shell_output("#{bin}/git-ignore template list")
  end
end
