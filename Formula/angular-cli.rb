require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.1.1.tgz"
  sha256 "fd8c687f751a1a2adaf479836416f0b0f11196bbd4ec82b8f28595bd3e1d519f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c6c7f4f205c1b2d8aea7c1686b65a072431dc5dbb629f39b2a12cb96f5ee8951" => :big_sur
    sha256 "89de32c990c7154e902a849bd30fe8bcbfed9eb8a75556c9c1a89d2e93df9e66" => :arm64_big_sur
    sha256 "3804bc1027bae1eee72cdff60d5892c2cc28e6a987086771b3e7ffba711cbfac" => :catalina
    sha256 "9cac080ce891a55701a4dbb2546dbd786a774a0e1e7b048b0fdaaa5022f13669" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
