class Goasitop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/context-labs/goasitop"
  url "https://github.com/context-labs/goasitop/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "4e3f2da4c7a20cf84abe618f105e8c8abbaa1279ec3924b4f55a0bd7d874ee0b"
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
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/goasitop --test '#{test_input}'")
  end
end
