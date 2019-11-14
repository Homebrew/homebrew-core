class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.10.6.tar.gz"
  sha256 "7736baea4fec708d92fa14ff78d41d05b9e54aa7fa71b12d0fecda69c365c62c"

  bottle do
    cellar :any_skip_relocation
    sha256 "749ca61148445a8eb7b85f337338b18440f7d827b2a5aa8f4ff5a795bb225475" => :catalina
    sha256 "c1fab755becd208c8e52fdc3cf013224fb6ac5a712036ce59b310ed24b08f3b1" => :mojave
    sha256 "cb6670b3261f2d883d4ea0c46ec0b083a2fd0d5cd7dbd984afea1a936af23de4" => :high_sierra
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
