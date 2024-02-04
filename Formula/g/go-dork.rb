class GoDork < Formula
  desc "Dork scanner with multiple engines"
  homepage "https://github.com/dwisiswant0/go-dork"
  url "https://github.com/dwisiswant0/go-dork/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "7c428a0e36ea05c6725aa508c8c69cf662a95c6e582c8e2f770bf99ea185a00d"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output(bin/"go-dork -q homebrew 2>&1")
    assert_match "https://github.com/homebrew", output
  end
end
