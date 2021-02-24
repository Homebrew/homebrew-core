require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.30.tgz"
  sha256 "597425fcc3ad8b14198265f624321259d68309fa6b802ba1e2da845809897a2e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a716cd8a4584b51e55a598f24e20372fd561492d4af43f5273c4d1dd227e313c"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee3b4c6c18b59ff93696d8bbe570fe579456b0aeca880ddfb4d404c11ca5d562"
    sha256 cellar: :any_skip_relocation, catalina:      "a6744729161e3b04f106a06651131cd64e9d1bbc65717c1fb89a52bb78d00fc6"
    sha256 cellar: :any_skip_relocation, mojave:        "3e39b4d777afe68e7f2fe260ea7c2e7975ae0095d2a813d41c56e61f3463a6bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
