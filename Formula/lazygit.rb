class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.10.2.tar.gz"
  sha256 "d9f830e2a121cd3314fd83633057110fcb2ccca1f3e655a8d5ff15ed426ff125"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1792c09ea2e9d48cbcc051b6e147a8328195b5fd936bcb823db4453e83c94e9" => :catalina
    sha256 "8a17ec65dfa5d4e0efd74538d7111e266ee11c864d0ca5f1503b37defa3d8278" => :mojave
    sha256 "90c65e8a382d0266516f7c21b178e8f6f0fd9cefd0a7260212892ca3560f3253" => :high_sierra
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
