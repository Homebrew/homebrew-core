class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.13.tar.gz"
  sha256 "93ca0847cd91874228b023d9feb967aaa819532f173fd6e19e2d00b8a6242e3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb86f01d4efe2df0b1964e6b57998e815a06ecab7bf21fc8d0275258557f9f89" => :catalina
    sha256 "1b981a8edf2a7879f49132328ea4c9f1d7a2b3b78cf08419592285c63802a35c" => :mojave
    sha256 "d4b36a7490b17f44ac21fdd7ad02ecefe7a53f978edad29284a12eeed606f31d" => :high_sierra
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
