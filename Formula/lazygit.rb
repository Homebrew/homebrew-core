class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.27.1.tar.gz"
  sha256 "f95831324f2ee890f83f8bf67d88b1d4464646f188a64ecaf6487af861e84200"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc549f9dc1ea348100cbbc1d9dc217c271fcdecc0a217e5bf7676664546187e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "493e63b1dbca85aa1558bf34f47839f88d2fa66f6235ef14f7cf430d3ff3013b"
    sha256 cellar: :any_skip_relocation, catalina:      "fce49b7bac3248bd95c1e83b03a332131969f801db8460d9167e491ec3c04cde"
    sha256 cellar: :any_skip_relocation, mojave:        "42a48870858a80be9a8476c7d1e0c1d3915e7e91893b8491339140fb3016fd8c"
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
