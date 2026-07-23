class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://github.com/xguot/difi/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "8b2d6dc51d0f39d56013434176724739287f7f6173ab7af27b03628f7ffc99e6"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb7cc1fcb8bdae5efdaa5f41b6434f52faaf865e9878876056acee4dc6a27c75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb7cc1fcb8bdae5efdaa5f41b6434f52faaf865e9878876056acee4dc6a27c75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7cc1fcb8bdae5efdaa5f41b6434f52faaf865e9878876056acee4dc6a27c75"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e3e67183a0cde228682b1bbfa39480bde6db17f46c75791b30601c1f54d5c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc13d2d4b7141a3ad93ca9a820f701d32395f2350f4d53a5b68dab630522e431"
    sha256 cellar: :any,                 x86_64_linux:  "9b99a475e408be9d9c79fa9d9b456a678d6984a8e6cc7c2e4a73b72270dd5f7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
