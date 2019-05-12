require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-7.3.9.tgz"
  sha256 "d9cf779176ffa78457b32564ce408317c6bf0fbaa945de63bbf56dcf85e6b6a5"

  bottle do
    sha256 "d329d7044b1f022968052ed53dc896439deebc7e9d44c29a66663c4a37553a21" => :mojave
    sha256 "cfd357bb53800e9ad79d4fe1dd169f1db4d5418190eb4d544c0717086cbf82b2" => :high_sierra
    sha256 "450aab9eea610acca59959108c5e31cc8ecf21b3528ecc81455961447f700dc1" => :sierra
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
