require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.40.tgz"
  sha256 "741b98108944d2733bc7c3dbd1f40a158e1dfab9a21a8d096b8ba3e6cd038eb1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "935479f1649d420685bd340b2e0c4670e642371c9b93861722c4c3482348c679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "935479f1649d420685bd340b2e0c4670e642371c9b93861722c4c3482348c679"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "935479f1649d420685bd340b2e0c4670e642371c9b93861722c4c3482348c679"
    sha256 cellar: :any_skip_relocation, sonoma:         "87d27b51d4a76784258cd5fb51bbb70dcc8c7d82a9895ffec7d8f609d184a624"
    sha256 cellar: :any_skip_relocation, ventura:        "87d27b51d4a76784258cd5fb51bbb70dcc8c7d82a9895ffec7d8f609d184a624"
    sha256 cellar: :any_skip_relocation, monterey:       "87d27b51d4a76784258cd5fb51bbb70dcc8c7d82a9895ffec7d8f609d184a624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "935479f1649d420685bd340b2e0c4670e642371c9b93861722c4c3482348c679"
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
