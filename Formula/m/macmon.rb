class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "15b1b7a7d050bcf78360a8b231c5841d1b051cd9a4f87f5ceee2b0f4ebc38449"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10a8e9145219b92688b0f6d4822e15463a0d789c2244b1cf74d053310f1c0829"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb4eedbbc7d95ced1788f5369f192b2a0dfb08971b6c9cbf9b2b4635f1068ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3671c4f2d0899b84a8e057f7caaf0ce03647b07abc4f0cecda43db8f4849f7b4"
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
