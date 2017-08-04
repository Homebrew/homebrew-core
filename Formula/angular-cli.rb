require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.2.7.tgz"
  sha256 "26a6c39d953aa8b99ef6aebbeae935d0582c296bfa04cf85722c598386d3a611"

  bottle do
    sha256 "bd70369049a5e588692cee41cd608df90220304a614686ba060a009b4a5dc6cb" => :sierra
    sha256 "189a933406dd26757dfbf4492c5dea8058b583518d1672319323ee02efe0f41b" => :el_capitan
    sha256 "76a0c5c80e9e0c01d8e579dcee0a296a7cb20b2669586c9f9ed7b310f7edc8e6" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
