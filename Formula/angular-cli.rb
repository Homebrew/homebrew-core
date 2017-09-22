require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.3.tgz"
  sha256 "e95b42158365982b7b5106b02699c2ebf8d8edee818bb57d40fda5a5a3ade9ef"

  bottle do
    sha256 "51d472a179828597f87f336e26e86678723c143ba0997f4ade0019ba09c65b09" => :sierra
    sha256 "592ef3395973c8d7a6975953e62bde752ef72d82650148b8da328d17b95babbd" => :el_capitan
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
