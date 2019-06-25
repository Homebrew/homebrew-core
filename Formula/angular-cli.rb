require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.0.4.tgz"
  sha256 "152771e0f91ece2c045f432b57cbc6946282f06b71ccfbed55ec8cb8b1018a0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5a8db4b3519a6dd83ff444d9e0f77d745b79b622faad778057987005aa10c8f" => :mojave
    sha256 "8a63bf9ee15d4cbb07697b32864b5ec8d2148df013899a33b465e2e0d38bd47d" => :high_sierra
    sha256 "a0995a834c31e379392043d488ebebb9b1695d2111a387e978b934dfe7afc24f" => :sierra
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
