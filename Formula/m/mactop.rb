class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "8674e03df4253e826d00014fa0399f42454df99f83e0073b59e686f701363db4"
  license "MIT"

  depends_on "go" => :build
  # Restrict formula to macOS on Apple Silicon only
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end