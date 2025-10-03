class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.2.1.tgz"
  sha256 "b48a946d7bfff0309f4d6939c9cf81d664f500f790461ad705cd15558a60f220"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6e57cb4f064b2f39ddc0773eb40fde29c1691dcb821d032b0069e49b2868dc4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
