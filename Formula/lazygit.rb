class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.32.tar.gz"
  sha256 "386a9c780580fb541399bcfef77b2444367b9e90ed629ab92af1607c4bc79245"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "260ce5ca676cf93678ed52c4ec24048a94ca34ae87a681df568630e9db1957d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29445f834b5d8b32868c5f848bb0b6c5f65bea7e8c734ab908c0e92326fb1c77"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb9ff851384e34167ccef13fcc8b71351e282e37a83d100933c8f897cc035b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c05bdf57173c9cb41b6362e7d537db6f53867d34f7fbc254f9fc6140702d941c"
    sha256 cellar: :any_skip_relocation, catalina:       "2ccbfc02b6e40f6e38b55341933c288f60eb92c77ceee4d8423af222fca5b4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044e81ab10f7a5446c05ea71623f4ee3be1bf00429935d6222c54cd3fc0d00b2"
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
