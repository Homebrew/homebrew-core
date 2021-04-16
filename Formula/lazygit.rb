class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.27.4.tar.gz"
  sha256 "8036c9b9539599fe9c112ed46d6234b3139a9dddc188b05cfa3bccfdb01422ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afc878349425da834b819f76d4c087fd4acf39d17248798f246e498afd36bc65"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7d6fcf9b61803cd70b3132d8c9c5b32eaf3f6b0961ad257cf20da39d7cc31df"
    sha256 cellar: :any_skip_relocation, catalina:      "a1eda3ce272ffa227ed403c93fa67e669c672035d4a55fa6c1573ebdb33e91fe"
    sha256 cellar: :any_skip_relocation, mojave:        "3331bcca8eb4381437277f13ce60d4f1223d43a7e2d362d495e1196f158f5e98"
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
