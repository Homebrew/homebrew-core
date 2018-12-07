require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-9.0.0.tgz"
  sha256 "25a78d1369ddda3f12c6fb1822a148e577d1d3262b79f8f3b5029bd15ee09c74"

  bottle do
    cellar :any_skip_relocation
    sha256 "71d908b52ba138ce4e83a78360ecc7c3c957a569fcd0d28eede0bcbfecc3e43e" => :mojave
    sha256 "9bf86c7cf7c0248a524d2f778f3a27a0525eebc1f5cf3973e3e201966dece1b1" => :high_sierra
    sha256 "5519abc81f420e1d670daf2b545f1d99871b8cd4374c072ccd98ec71f613233c" => :sierra
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
