class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.18.tgz"
  sha256 "f966d21aabddaf879deb6805b4ae953770c6d66558a00387261cd380274b5107"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7c912ba8c203e1f0ed08765fafd155b1f093a1017edf4235383e389bfea0abd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7c912ba8c203e1f0ed08765fafd155b1f093a1017edf4235383e389bfea0abd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7c912ba8c203e1f0ed08765fafd155b1f093a1017edf4235383e389bfea0abd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cb5dceddad264cd6ce54b8aabf05bbcfe04dfed2b081c901d4caa4e0f84ff39"
    sha256 cellar: :any_skip_relocation, ventura:       "7cb5dceddad264cd6ce54b8aabf05bbcfe04dfed2b081c901d4caa4e0f84ff39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeeafd89da6da5469334f85f116ff93f1d98346391f598b2237a4a5e3513fd6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
