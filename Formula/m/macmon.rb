class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "791336207740ff2e2f5494ebd9250e45eea57c4aa496a9255ecde7b2518fb712"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c4a08eb9ef5a4dc0d03f4f8d042ceed0757406e901d9121d6d7965743ade58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b56d5b51966957a43c9899dfbb766e623fdf43021d59147bb047d22052daf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb50d512e081d21d590426196c8e5de0a95d0b8ed70933a548acfefa532a2adc"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
