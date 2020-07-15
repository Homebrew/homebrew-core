require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.3.tgz"
  sha256 "dc3a7a2b90da92ef63fe84cb69b289cba09de734565b7f0354e67533d75fd801"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "015e0e447bbcfb32c01e4a3f2f8dbcbca6e9d3ca7a3dba85dfabbd9d491503cc" => :catalina
    sha256 "224bd248c64772218e035497c7f644ed942820d05a52f18a22cb3b6bd19c552d" => :mojave
    sha256 "650255370794599d188ad860774ec203bb6a8e64409be517a59f6c40258116b7" => :high_sierra
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
