require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.3.tgz"
  sha256 "e9a3a58652fae99b877aeb2ebd49540a6b09e29580947e106ac2429406840b12"

  bottle do
    cellar :any_skip_relocation
    sha256 "310198d5639754a58d32d4fb16804c4304282319d03f43a505504943f3fd570c" => :catalina
    sha256 "4cd6c71c92d72fcc00809da2367694c69bbb73065300bbc71a67171c3d8103d6" => :mojave
    sha256 "fc18152e669ae319a8e12795886dab91b219fe411d467b1bbc2d0ef64163228e" => :high_sierra
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
