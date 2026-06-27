class Peco < Formula
  desc "Simplistic interactive filtering tool"
  homepage "https://github.com/peco/peco"
  url "https://github.com/peco/peco/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "480ba339c5b15ebb9eada276d5e25315ee5c36e878d86dcfc1ea17f54a27197a"
  license "MIT"
  head "https://github.com/peco/peco.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "323de7d5f3d9f0e575f9b017c805514b396e1a2d25c0ea15e5378279da8dca6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "323de7d5f3d9f0e575f9b017c805514b396e1a2d25c0ea15e5378279da8dca6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323de7d5f3d9f0e575f9b017c805514b396e1a2d25c0ea15e5378279da8dca6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ccbfdfee81da5ec438744fdff6a5e5d6ce4d6bb14def3fe806da90881946af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f26b8b4db22eb33007c301bedf8408146dd2189b478283cee3475bc54885bbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48428648fdfbae5e429763f95164fdd2fbb5007aa071e2eda4d386feccf5b183"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/peco/peco.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/peco"
  end

  test do
    system bin/"peco", "--version"

    ENV["TERM"] = "xterm"
    assert_match "homebrew", pipe_output("#{bin}/peco --select-1", "homebrew\n", 0)
  end
end
