require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.2.tgz"
  sha256 "92dfba4a910813342813080490f06ab9b1143d823d8987fd29b6673fb0ec0bd0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a7aa5c3041775be7157febc2e75f6d4321f33379c85ce3fd500a8ac1fc6115a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7aa5c3041775be7157febc2e75f6d4321f33379c85ce3fd500a8ac1fc6115a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7aa5c3041775be7157febc2e75f6d4321f33379c85ce3fd500a8ac1fc6115a"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cff0d0db0ce673a110ee800ebd44df25ecf6c9242253b6664b257850a2b4413"
    sha256 cellar: :any_skip_relocation, ventura:        "7cff0d0db0ce673a110ee800ebd44df25ecf6c9242253b6664b257850a2b4413"
    sha256 cellar: :any_skip_relocation, monterey:       "7cff0d0db0ce673a110ee800ebd44df25ecf6c9242253b6664b257850a2b4413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9a316d9d0f9627b479bc2efc59f8f1078b23cc4147312d426fad901a3017723"
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
