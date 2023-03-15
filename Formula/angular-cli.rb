require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.3.tgz"
  sha256 "1eb15913b86fe9030fd3e68dba3976eaca6b1e317c6a8d34d35af0e58f3df369"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, monterey:       "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c334c760c2332151a42dda6299ba42ec793b1bac39215da4381830ebd58f92f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da15f203828ee28556e08d4540a91d552f29bebb7b3441fbb94b0a3c83a43dd0"
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
