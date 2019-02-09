require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-11.1.0.tgz"
  sha256 "1751d347b1d252abb1977f46b8347cb7f257a776f81d912e15f70fc68ebf320c"

  bottle do
    cellar :any_skip_relocation
    sha256 "261c42aa0ad935931d788523fb068ac7558d719b9f2132958038ca362fdb7b65" => :mojave
    sha256 "a73137b4350e4452333872f373e73ff4b8cb852aa640d4a89b9c8d5e62aa42f7" => :high_sierra
    sha256 "6452dd1164c755beb442fbbed994712798e35eca4a6b70235cb93980a0ff4265" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
