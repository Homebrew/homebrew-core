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
    sha256 "5df556bba0026bbf403cbc2638132b284cae83cf18a432abd8dcc29f231df06e" => :big_sur
    sha256 "3191477a8584bd35e88def3b1e52cffa2fef1fe61580f8a4276d13462b70990b" => :arm64_big_sur
    sha256 "d08797e178e93ddf71babb1267ec57b6688677923650c1f18fefdc566987acba" => :catalina
    sha256 "5c29327fef5a6c5769f425f993779b97a573d3252e7378c0186e0b8f311f9e26" => :mojave
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
