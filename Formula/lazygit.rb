class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.11.2.tar.gz"
  sha256 "96a03b3e25b1b73e268ce2ce9fc63c11c43c67ba34d3901995c755fb932ab9cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "628a4b9a412f0e9bb99932555466f6406ba25fbd7d272da8512bde3517a17870" => :catalina
    sha256 "a8f4e409fc6d3c7aee63c4c4807334e7b5728db76e59f2f10283e7e06b17991f" => :mojave
    sha256 "6357c98322faae863afb991e2968b81483ffaf683af73be7f473abcd66ba45a9" => :high_sierra
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
