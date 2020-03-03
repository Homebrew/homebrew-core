class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.15.7.tar.gz"
  sha256 "dbec001beb1b1b382cfc0d30a1d6c38bd9fa88cd7aa7aebaaeebe592b4ed487d"

  bottle do
    cellar :any_skip_relocation
    sha256 "73940596cf5d97aae525eaf22c73125bdc602e6e77824659a42217f334fe297b" => :catalina
    sha256 "a8056e424f8f88ba1a889a96d0e55e4d82fc88e0c2dad5bfebe2988ce9489601" => :mojave
    sha256 "6511dcc64370025e99a9881f3c2d751250e3014c327cf136dfe8d8d6544336f8" => :high_sierra
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
