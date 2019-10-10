require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.17.0.tgz"
  sha256 "183e3e47217d81a9c539ba5878ec75c1d1d5b2c161225921b7cdd2a1de1297a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8de71d088d7371fcc8d7756c091080d674c1061e4b1c37f2a7e65638f5778d7" => :catalina
    sha256 "e59dcf2e68806fd6ed49f914896dae33f99dd399b869532d24f70263b4ff0db2" => :mojave
    sha256 "82dbae16ba08a5f026d8856721f3d3e7703c9c7c4318e60d8c3d99570662e215" => :high_sierra
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
