class KodeCli < Formula
  desc "AI-powered terminal assistant for development workflows"
  homepage "https://github.com/shareAI-lab/kode"
  url "https://registry.npmjs.org/@shareai-lab/kode/-/kode-2.2.1.tgz"
  sha256 "aac542c7a31c9fb0a6e3a73899a72a7cf0851fcd748cd9c6a9e1e53299995b5b"
  license "Apache-2.0"

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: true)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/kode --version")
    assert_match "Usage: kode", shell_output("#{bin}/kode --help-lite")
  end
end
