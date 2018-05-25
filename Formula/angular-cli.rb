require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.5.tgz"
  sha256 "25d584c80f462192fc70b91c242c6cc04c1f6ead54b3b774621c987597d993ad"

  bottle do
    sha256 "283af0df30e42cbb1bcce1efc8cdd20eaf05cbe767e7d9e7a17d701e2aa048ce" => :high_sierra
    sha256 "2b682b5428e1ccd6b869868e25eb6225f5d85bd48eafa30c25f0c4663eac3f66" => :sierra
    sha256 "880b3ba23e81c70bee66d4e89dedad5e509a6a0d139b13e4f6e724eb56df8e1e" => :el_capitan
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
