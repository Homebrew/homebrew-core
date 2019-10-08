class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.8.2.tar.gz"
  sha256 "aaaa4cb789d387a08eb46ca95159561cdb4a2f4e70315ce68ed61bbd30fe24ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "04317d3625563735d60f8e7d7871693da99867ef463b09072209a377c32e14ac" => :mojave
    sha256 "f6c93c2b35b269a83811cf10bf8a58ad5af108806777a0c6e489329621432721" => :high_sierra
    sha256 "31308b34df92ff5ec10195e117729ff475fabce00fbd0ed64c01d68198b221d9" => :sierra
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
