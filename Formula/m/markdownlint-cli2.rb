class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.13.0.tgz"
  sha256 "db7d09de0f934fb8146b5a2a01a819faf361aff36099de3030825d75ae1c4178"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, ventura:        "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, monterey:       "bf40acfeb3a1b478fc496a1153cd5bca9a478e0b4ed69e15ea0a5f719779236b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d991a96a95a0a0d3e1cfe468b9f5a8921de1ebe957ea60e544c60e63d0407c18"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-good.md")
  end
end
