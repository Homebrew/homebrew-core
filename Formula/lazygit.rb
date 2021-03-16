class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.26.1.tar.gz"
  sha256 "7bfda18345993206d4d388ea0370e9b54af0354d37f4a64803461889b361d547"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8017d261de1d18902e2f2484dedb32d238087ad8852151a7b6256bcd265aab45"
    sha256 cellar: :any_skip_relocation, big_sur:       "238b79f22a4258f99f87e8c55d01d51f4357497df7fa22d600ba4fee043bf894"
    sha256 cellar: :any_skip_relocation, catalina:      "ee8129ff284fab35dffd4aecf4ae76db209a9e58f8a04ab9a8701583a35af1b4"
    sha256 cellar: :any_skip_relocation, mojave:        "471e06c06c5b25935083501ab76202dc7379effd2224e8cd52416678f2ab7929"
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
