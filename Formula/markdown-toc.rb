require "language/node"

class MarkdownToc < Formula
  desc "Generate a markdown TOC (table of contents) with Remarkable"
  homepage "https://github.com/jonschlinkert/markdown-toc"
  url "https://registry.npmjs.org/markdown-toc/-/markdown-toc-1.2.0.tgz"
  sha256 "4a5bf3efafb21217889ab240caacd795a1101bfbe07cd8abb228cc44937acd9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fcb47b953cf9becfdcf24c6de36fbff454877e4c05ac47bc40be8d2df76ba0f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "- [One](#one)\n- [Two](#two)",
      shell_output("bash -c \"#{bin}/markdown-toc - <<< $'# One\\n\\n# Two'\"").strip
  end
end
