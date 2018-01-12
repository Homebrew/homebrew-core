require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.4.tgz"
  sha256 "8c97c54d541c9ef701fb81a900667fc4388b8d6eb5a09f61f780ef1b0a484df9"

  bottle do
    sha256 "9c140bc4a914c64fbaa185bce44ecd1d5f097bb01326da0be2852a9b8f061c0e" => :high_sierra
    sha256 "5876ef72f09d8502b5c769333a550991ef42ad88a45dc347c8f59fee6bcfa99e" => :sierra
    sha256 "3a4ef49dac232cdba89b53478c0f565059343af4ed317487b8bb8c492c2d922d" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
