class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.20.tgz"
  sha256 "6688e9ffcd806cec191fc2b32e739764303066030aa9b65d73cec9a14fc66f12"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076b5bdcd83b269218c8605c8d56c62660f3956f672d835781db5de4c0f16a62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "076b5bdcd83b269218c8605c8d56c62660f3956f672d835781db5de4c0f16a62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "076b5bdcd83b269218c8605c8d56c62660f3956f672d835781db5de4c0f16a62"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2396a14a4e4b1d52cecb2b6dfedae6ec6354721c05f1b1440ee62fa0e21b3a"
    sha256 cellar: :any_skip_relocation, ventura:       "5a2396a14a4e4b1d52cecb2b6dfedae6ec6354721c05f1b1440ee62fa0e21b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076b5bdcd83b269218c8605c8d56c62660f3956f672d835781db5de4c0f16a62"
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
