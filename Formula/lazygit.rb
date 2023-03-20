class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.37.0.tar.gz"
  sha256 "8545f3cffe110de80c88859cd11b42eaccb71f4c239c5bc2bff841f623438296"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "401a0c31032572f855a5f2207d78f318edfa082cfced8c586911d9aff711dfab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56dcb01075d98bac3834eca8f5023822b255c955e4087d58c8a420516eea8d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "564d259b773bf98fd0f5cc5e5c0ccffed6b948d2f0c64cb72bc23d064cdd0979"
    sha256 cellar: :any_skip_relocation, ventura:        "7a7f25fdb5cb29c582e1b2fabaaec87064f295bb6d545b52bba7f19c34605b01"
    sha256 cellar: :any_skip_relocation, monterey:       "908b7ccde3658256507427bb9586d594797d65bda3e846e029a10076658bab59"
    sha256 cellar: :any_skip_relocation, big_sur:        "01e9bc26a8b7cc95dc8f667a10fffb680436c2b19b2f8c58bee05f04396005f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35c4642f0ce88752b94add6464bbf519120ba4fd3d40407b654923c05ca1e8e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
