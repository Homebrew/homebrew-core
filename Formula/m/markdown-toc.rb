class MarkdownToc < Formula
  desc "Generate a markdown TOC (table of contents) with Remarkable"
  homepage "https://github.com/jonschlinkert/markdown-toc"
  url "https://registry.npmjs.org/markdown-toc/-/markdown-toc-1.2.0.tgz"
  sha256 "4a5bf3efafb21217889ab240caacd795a1101bfbe07cd8abb228cc44937acd9c"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, ventura:        "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, monterey:       "4a99991af6d567dcdc4f34d0a7af4190de420dfd435b1b8b5704d6bd978776f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fece6d2074d2656d6bb80409133100048172bea6d3541954bf850355940f7f55"
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
