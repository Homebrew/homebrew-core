class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.28.2.tar.gz"
  sha256 "4925089bff0fee55ccc495fdcc2d396e48e04d16ad8d6681b6cce7b10eefa2b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fb9a13c887823ca5e8efaca4bf86a796e51595a64141221f9e0a72f560b1767"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcb6018b843fb4fb6dc92e48ded51cedaf70d0f6d1d31777ec54689b78ca55f4"
    sha256 cellar: :any_skip_relocation, catalina:      "e09aefaf4b43521e50cc340a9f446e79153a0bf7fa246bf3d2eccfecc967bd39"
    sha256 cellar: :any_skip_relocation, mojave:        "2671c9373f691ed68d8a9f7b288089163faabf06db5674b0a3414e50cb95691d"
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
