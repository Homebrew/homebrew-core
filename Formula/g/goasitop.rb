class Goasitop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/context-labs/goasitop"
  url "https://github.com/context-labs/goasitop/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "ce583ba1434589544cb7e1049ce24123a66c6e0b715c43fe3d0e98642d393be5"
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
