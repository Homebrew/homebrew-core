class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.27.4.tar.gz"
  sha256 "8036c9b9539599fe9c112ed46d6234b3139a9dddc188b05cfa3bccfdb01422ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fb8d13b17ddfec60f627efed20d8cf563e1f56e4d48eb80a9b025fffe4634d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ec55099d6b7f78d590e5345fa1dcbeebf9f13304d034516d28d0f5a193e25084"
    sha256 cellar: :any_skip_relocation, catalina:      "d30bb7037fca0e3c40e05df73bd31fe423341776a376e2a6bba81b3009130232"
    sha256 cellar: :any_skip_relocation, mojave:        "2f9102967b41ffd209cbecccffe7689a1527d3e77b9ecdeb3b1e3ac5f7dc5028"
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
