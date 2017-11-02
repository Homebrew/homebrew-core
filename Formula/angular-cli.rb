require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.5.0.tgz"
  sha256 "61ac71406c6c3c57dc5719a832bc6c7a2da0882aa52485a677ca8a2b89c6c3b1"

  bottle do
    sha256 "a612fc468888e25cd68818169524f0383950493d488efcc88b32fd88324f1a58" => :high_sierra
    sha256 "72672f06de78db298daaf6af1d65e9354a579abfcc912457ad4ae72c31347016" => :sierra
    sha256 "418c42a2d3dbc172d1c1ba11111eaaf3f028c256bd84c520e18e28717ba6a4b3" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
