class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Go Lang"
  homepage "https://github.com/metaspartan/mactop"
  url "https://github.com/metaspartan/mactop/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "26fdc1118ce73c26430b76f28b15f93c5122016f5d5502bc09733dae945802dd"
  license "MIT"
  head "https://github.com/metaspartan/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55579ed1da40f4d68b28207a309aec6d7c2140ddc54d9eae5addc1ff70f5ad39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "facaef487632d04f416094102d321c42083e32474714838abf730f0ed396ed86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea34481fad33e2c2672478f3fbcaf1dfa5b1a9d22252941db36fe31983ddd873"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
