require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.3.tgz"
  sha256 "b38d7375cf8e09947df053fb963cecf86387fc79bd7afb306ac4e2b5a9e2ddfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb5731304857f9fb8cd581ccde2160d1beb3d3cbd73ee59f6f99bc2900ca3640"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb5731304857f9fb8cd581ccde2160d1beb3d3cbd73ee59f6f99bc2900ca3640"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0a990efc37ae729064d234761c2c6ead84816f74b6e9849f0fadf89da326ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c0a990efc37ae729064d234761c2c6ead84816f74b6e9849f0fadf89da326ef"
    sha256 cellar: :any_skip_relocation, catalina:       "3c0a990efc37ae729064d234761c2c6ead84816f74b6e9849f0fadf89da326ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb5731304857f9fb8cd581ccde2160d1beb3d3cbd73ee59f6f99bc2900ca3640"
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
