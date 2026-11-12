class Inshellisense < Formula
  desc "IDE style command-line auto complete"
  homepage "https://github.com/microsoft/inshellisense"
  url "https://registry.npmjs.org/@microsoft/inshellisense/-/inshellisense-0.1.0.tgz"
  sha256 "60bcadcf98084e73e8ec40f566afe524aa7601363d88f72b08bd20c363065d8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d271335967351d5ced28094811a7934304a825f920ef911c21bd92a22ab7ade"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3d271335967351d5ced28094811a7934304a825f920ef911c21bd92a22ab7ade"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d271335967351d5ced28094811a7934304a825f920ef911c21bd92a22ab7ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae151d3c4de4241580f2472516e3ae0ccc67b0f9c0855219fe42410454408938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "84c934e9024a34aa9bd4633779dc5631340444b337a2ceb83aa0f626d3a37f6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "inshellisense session", shell_output("#{bin}/is --check")
  end
end
