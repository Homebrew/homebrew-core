require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.1.tgz"
  sha256 "e5fc35d70ca0b6753102196fa93c28cb07a2238971ae2342bb123af442d63bda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e91be687d7ead24ba78372746403acd9dc03da87de2564e1709c984e7f4946c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e91be687d7ead24ba78372746403acd9dc03da87de2564e1709c984e7f4946c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e91be687d7ead24ba78372746403acd9dc03da87de2564e1709c984e7f4946c"
    sha256 cellar: :any_skip_relocation, ventura:        "8a3d6267fe93438fb9ed143f1f4c78c635a8d6c912f80a5abdbf533294f72c14"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3d6267fe93438fb9ed143f1f4c78c635a8d6c912f80a5abdbf533294f72c14"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a3d6267fe93438fb9ed143f1f4c78c635a8d6c912f80a5abdbf533294f72c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e91be687d7ead24ba78372746403acd9dc03da87de2564e1709c984e7f4946c"
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
