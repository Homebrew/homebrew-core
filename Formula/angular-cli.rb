require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.18.tgz"
  sha256 "e191af18a80a585179a853e02f8541d9057f82ddb280f3db59ef90c9b74c9a89"

  bottle do
    cellar :any_skip_relocation
    sha256 "62372cc44f823488cb95de9fe780a17df9c35e4ab8e4b1ad4da00913dd39aa72" => :catalina
    sha256 "9e43bacb202679c4cf9380186fc890fe4d9d7ba9c736d970c24003a60f0e17d0" => :mojave
    sha256 "eedc285075541304573fdbeab7cdd32d1082346d9775fadd14c8684914255b2c" => :high_sierra
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
