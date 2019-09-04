require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.3.tgz"
  sha256 "02d589a62632797c2309ca4788b0bed7fade526e897ca692e3cf9aef7d9e9ff7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7abee6f5bc6a18743dd7d019b647d1faac0764aa7e4f2fd8a025ce2e081432f" => :mojave
    sha256 "390164712c08e1f432d52a82f464a7d8c035ef929ee5dc0c50d6bc05e800c5f0" => :high_sierra
    sha256 "373c24a9e61eb554e5bae9a5139349237c0f4041dfe3c9ef17ca263e01025f23" => :sierra
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
