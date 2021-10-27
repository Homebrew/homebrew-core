class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.30.1.tar.gz"
  sha256 "ff304a989d9852f9871d7646c12d63d92f8994ac70f713fd2eed13965aa3bab0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b156d6d535fe8080431e5fd90595ad17e0a0a26125b97b013fbc4a3682ae25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bbd7038f83cefabe7493764ed86ae65473a10871ff76375e1bf82c0173bb365"
    sha256 cellar: :any_skip_relocation, monterey:       "4f72968a7e1144d56f80d76c74f1bb7a49d227ebb8a5a19bac59a4a723a63af9"
    sha256 cellar: :any_skip_relocation, big_sur:        "221473b9e166d73ac67a62b8079a3ca9eab4730902f10995f4c518711f9014a4"
    sha256 cellar: :any_skip_relocation, catalina:       "b33528519359ea653ef19421c599d9d9a13df0d9fc6f4c66cb65887b88dd9c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee00fab488f78c55dd9ae21bf2104f942691ef7efb1d690e1b4a7f0bf17e757"
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
