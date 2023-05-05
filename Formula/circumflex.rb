class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.9.tar.gz"
  sha256 "4d1280a03223ac38f084be305880527250c315f6c6658e2444b6a295e8ec147e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "933bb5f3f34fa6f794bd012626d6ad483a658a876373055c3ba0d8f84ed6b123"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "933bb5f3f34fa6f794bd012626d6ad483a658a876373055c3ba0d8f84ed6b123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "933bb5f3f34fa6f794bd012626d6ad483a658a876373055c3ba0d8f84ed6b123"
    sha256 cellar: :any_skip_relocation, ventura:        "0296fda06be305f53cdd1aea367dacd7058849e2e3a3ab6ee0bebf5152851ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "0296fda06be305f53cdd1aea367dacd7058849e2e3a3ab6ee0bebf5152851ca4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0296fda06be305f53cdd1aea367dacd7058849e2e3a3ab6ee0bebf5152851ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0927e057c00d3a82d0951d4fb7a38822348b8d7f8a259f689e12c044f9ee02c2"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
