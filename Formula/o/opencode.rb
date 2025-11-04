class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.19.tgz"
  sha256 "2b6497856ce1b38b0365cc6375f1f6631953e40db8686c2f243b3c3d2c8defc7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0cd49dd18cbfb1cc4831336aff120d4292300f13e07ed81ca1b2c11e914ffc9a"
    sha256                               arm64_sequoia: "0cd49dd18cbfb1cc4831336aff120d4292300f13e07ed81ca1b2c11e914ffc9a"
    sha256                               arm64_sonoma:  "0cd49dd18cbfb1cc4831336aff120d4292300f13e07ed81ca1b2c11e914ffc9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "58b3e37b2ff2678e4bf154c6dd2e0e439186ca6018551273269ed21b1b765740"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "112b9f1d444ef1d2e97d68d29a8f4f130930d3c97e1efada31bafc1757d4fda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd73a7b001939a74b5c0187614a663abbcae8fdd6811f23b5a6090fff3acb7b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
