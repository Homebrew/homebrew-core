require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.1.5.tgz"
  sha256 "09f1fdf05007f2ff13db4a394ee1d0c58f18df4c0f7a44d13ca4b94c6cbea8af"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dbdedf288a60da3fd1a2569efd2859187c4347e287d108e77dd80d59129ead7" => :catalina
    sha256 "aca0c579356297d2e52e1269a7dbc3fb93bc64e687c1915afa8f5e849d8e1400" => :mojave
    sha256 "0a48fc439574dbb74a2d1239dc24c6e3a336fd4bd8b7e8b234925b8b7a392e69" => :high_sierra
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
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
