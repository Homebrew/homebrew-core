class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.5.2.tgz"
  sha256 "e80c872b32b92b8be2f811a139c13de147773aa21e6fb8235f6f19afd016154a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c7dd50ac056d4478cbdc8ef4971c92f4ef7d5be08549306403a3e4a9e8e181d6"
    sha256 cellar: :any, arm64_tahoe:       "c7dd50ac056d4478cbdc8ef4971c92f4ef7d5be08549306403a3e4a9e8e181d6"
    sha256 cellar: :any, arm64_sequoia:     "c7dd50ac056d4478cbdc8ef4971c92f4ef7d5be08549306403a3e4a9e8e181d6"
    sha256 cellar: :any, arm64_linux:       "f7fb4b0e833fd9314b1c5a7d20c72870b1eca105a2f0665e3244abf3604fc559"
    sha256 cellar: :any, x86_64_linux:      "685f81701ef41af49cd2b35bd498365c299844d08caab2e227a67ba3d55abd8e"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
