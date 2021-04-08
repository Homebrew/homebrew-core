class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.27.2.tar.gz"
  sha256 "0e3322540095cd4fbde546f23bf89c7db288800cc4a142a8dbcb1d34b31b7a15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c064c16b83ace3e7aeef910783905a0d493a589d710425fa32035c7c1300632d"
    sha256 cellar: :any_skip_relocation, big_sur:       "b93aa10aa75e2edf38615dbd546fc1ced689970f0407dd53c37072ce9c0958b1"
    sha256 cellar: :any_skip_relocation, catalina:      "b2f0b012d85fc00d45af6dd1b55e83d145670b36971779d11071692277d41557"
    sha256 cellar: :any_skip_relocation, mojave:        "263907c1723d682d5aff3432efc639a5a9291d5bf7a9abc609d51350ffb625de"
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
