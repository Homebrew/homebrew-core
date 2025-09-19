class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-0.10.1.tgz"
  sha256 "588f195583e7e00d269405e12f6a3cdfbb136be30edda645c5c235434ec65e20"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0d28b28c9477340068d577d364db37b48761666d2ae66db84dd4bde7d41b7561"
    sha256                               arm64_sequoia: "0d28b28c9477340068d577d364db37b48761666d2ae66db84dd4bde7d41b7561"
    sha256                               arm64_sonoma:  "0d28b28c9477340068d577d364db37b48761666d2ae66db84dd4bde7d41b7561"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c62505672272fde147e9fd381942e26c4f4ff0d22e416e37845d188a91b58d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec74305d1df263346c50beab22f1e267310ad53763753ebae2200ad00dc2ca6"
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
