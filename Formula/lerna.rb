require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.17.0.tgz"
  sha256 "183e3e47217d81a9c539ba5878ec75c1d1d5b2c161225921b7cdd2a1de1297a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d999958fc357103eb874d566870bcb0c0fe3d90c28dde49e057390a34b3a1d4" => :catalina
    sha256 "fe85955729816eea7235109b1d4ff7b399c241d4e977c4e9fca520940bdf8653" => :mojave
    sha256 "2e4e7f0522dd07d3ef02b012dd464c1b68a3fbda95797f1137f72e304656a7d2" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
