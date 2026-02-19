class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "57f70ee446dacc1aedab6e4659528f6ceab894d1499b8e955a5b1b275997cc57"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "275314c7378530c20a4302eeb631e73aed1d4da9d54669d5e0044cda44472aca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "275314c7378530c20a4302eeb631e73aed1d4da9d54669d5e0044cda44472aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "275314c7378530c20a4302eeb631e73aed1d4da9d54669d5e0044cda44472aca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a68d6c01c2e886e6500cf1872b3e573af3990dc6b571c48882a1b9549e4f4103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "661b18c3e8814fe367ee68a1e7514744e7054852316e112c6a6eddd50a290870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5472434545c5295c5cd8c26054b26618bfa5a3817b27b414b03a4e4cf2269fd1"
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
