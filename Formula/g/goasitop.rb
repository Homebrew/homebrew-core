class Goasitop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/context-labs/goasitop"
  url "https://github.com/context-labs/goasitop/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "e5e2211eb506725a4832a5b5096e2e6a61d3bb7ce0ab58674b50b1ec79187b5d"
  license "MIT"

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  # Restrict formula to macOS on Apple Silicon only

  def install
    system "go", "build", *std_go_args
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/goasitop --test '#{test_input}'")
  end
end
