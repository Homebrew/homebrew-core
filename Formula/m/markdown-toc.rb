class MarkdownToc < Formula
  desc "Generate a markdown TOC (table of contents) with Remarkable"
  homepage "https://github.com/jonschlinkert/markdown-toc"
  url "https://registry.npmjs.org/markdown-toc/-/markdown-toc-1.2.0.tgz"
  sha256 "4a5bf3efafb21217889ab240caacd795a1101bfbe07cd8abb228cc44937acd9c"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2817812b6a1d6a1e613ad337524dbd04afcc3ee306c8ddecab56c6835468d11c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "- [One](#one)\n- [Two](#two)",
      shell_output("bash -c \"#{bin}/markdown-toc - <<< $'# One\\n\\n# Two'\"").strip
  end
end
