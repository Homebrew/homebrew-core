class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.9.tar.gz"
  sha256 "d0d8e0d86384bbdfc6f354f740b5396d48ca639c6c63b1d0c65cd70048fdb598"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a9a31685d341c1a384acbca8fc47de38ae7733d2b54db950717107e8a02230e" => :catalina
    sha256 "9a2a9e1d9a641f6f45545f16f68fe22565e5abebbd3299f1c812ad1713363c68" => :mojave
    sha256 "8d48ed6d38534ff6dc128557575d23958adea96c98d8b8ef2fca09a3ddc75a4d" => :high_sierra
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
