class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.31.1.tar.gz"
  sha256 "b16d18bb15e30e25882da8cf3c1706919bc7953ea0da319f32ee503721ca88c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b6e54ba93cc2c18b6da7755b59dff4d6ba57431b8ed3bdddc8eb01075c51fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de5d79dca8f5eb818ed32d241ce9c38bf0296289b788e0d43f92175968d27bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "ee44df16e0f9e88b71163c6841db95630b6f300072387fd17447f7aa5ba66bc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7975f2485da4d93753126587298da4faba662436f228e62326dfee31320210"
    sha256 cellar: :any_skip_relocation, catalina:       "4c485529643a75cb7f28a9ef6e1274defb4a1794a234edec56d918921f5a9cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449bc48da4a2dcdac2ff30b68afbc56a16c47ce7d0f558ee2ce3eb191226067e"
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
