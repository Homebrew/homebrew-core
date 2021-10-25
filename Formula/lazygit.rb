class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.30.1.tar.gz"
  sha256 "ff304a989d9852f9871d7646c12d63d92f8994ac70f713fd2eed13965aa3bab0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393598282307b54f828ac8d9b7c9ec71cbab6db3e42f7a6d63708e54e31af379"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc3703fa3c8817ee39a6e3bbccdac73d908796d7ef942035b0c0261af1e8362"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8f39c51540da4415a83374a5a97983f963aaed7cae26c0a2eb1491b1b25ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "478558d51847a2340d633326a8d7cc6be8480ae1817f7041bf99b14ab91225dd"
    sha256 cellar: :any_skip_relocation, catalina:       "82b1dbb31e577d4bfef39d685b75a6a3088a8a65d0079868a94ed3d48348e7d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "215ad0bf0b5e3ae5b928c384e2ee0f5995871e836e34439c29b3559be27b6e4f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
