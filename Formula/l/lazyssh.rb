class Lazyssh < Formula
  desc "Terminal-based SSH manager"
  homepage "https://github.com/Adembc/lazyssh"
  url "https://github.com/Adembc/lazyssh/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "36cd630b3cd9447e88904171cbb64944aeacbbd62c15db66d8a0e4a4486ffe88"
  license "Apache-2.0"
  head "https://github.com/Adembc/lazyssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9e98e23b086b317416d036013ed8651e58aa1de3876fa42b444bbec0439ee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9e98e23b086b317416d036013ed8651e58aa1de3876fa42b444bbec0439ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b9e98e23b086b317416d036013ed8651e58aa1de3876fa42b444bbec0439ee8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5d24b067f952f013bb592732dafdf1a365d97e74d69bd6fcdb2b4feb256dd37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4704398e7e214b922e0bf252f3c909bc09010210fe236bb06de27853066f845a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10895dcda0b9e2f93fe3b21a24eccfb22667fd9b03d36a2fb7983613e2967355"
  end

  depends_on "go" => :build

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    # lazyssh is a TUI application
    assert_match "Lazy SSH server picker TUI", shell_output("#{bin}/lazyssh --help")
  end
end
