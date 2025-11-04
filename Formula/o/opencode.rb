class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.19.tgz"
  sha256 "2b6497856ce1b38b0365cc6375f1f6631953e40db8686c2f243b3c3d2c8defc7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "35a8c57ab70de52910b58ffdaf32a651c3ef5b976dc12c5270f2ecada00655f6"
    sha256                               arm64_sequoia: "35a8c57ab70de52910b58ffdaf32a651c3ef5b976dc12c5270f2ecada00655f6"
    sha256                               arm64_sonoma:  "35a8c57ab70de52910b58ffdaf32a651c3ef5b976dc12c5270f2ecada00655f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "570cd772e624fc99b9f71dc624e8485c64668a953e46171a9893972e10355227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175c16b709cb8f59ecfb3fd6a7640cd5ce768ee99ea422bb397b5c09ceea2880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf905765ea01cdb5e03a70604c07573afd767c22db8ce35431f7c9d0a4fb80e"
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
