class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.8.tar.gz"
  sha256 "35d0c94fe030e3686f7f5ec5017ad92be0d24974a14459fac37f22722566b06d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e51ccb8635f7da4070f8bbc398e0b9f9fefc6e4884b563ce0ccd6c7b45d73096" => :catalina
    sha256 "daddd1dd982a6f0dc16fc0bf5e4b819b0161da733c310b1dbe0b75c91e044409" => :mojave
    sha256 "f43a85b7a5cb139b38237878628d08ee55484bc8d4ddeb73da9925a688bad355" => :high_sierra
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
