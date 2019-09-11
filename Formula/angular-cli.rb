require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.3.tgz"
  sha256 "02d589a62632797c2309ca4788b0bed7fade526e897ca692e3cf9aef7d9e9ff7"

  bottle do
    cellar :any_skip_relocation
    sha256 "47a73457a1a7406aeb6b799940c0d781e83c137ea7e1e1d484f14912a9d42593" => :mojave
    sha256 "48f1f66cd56a0e3f4dd7dfb655cb34dfa6cf198331852abd074548cc5f8dafe1" => :high_sierra
    sha256 "a8dc879f09669b9b0420d684fdec6365aba2b5fd759096154baaad67a02f24e1" => :sierra
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
