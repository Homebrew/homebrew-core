class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.7.0.tgz"
  sha256 "34fca3034e19ac71def9c8596b17ee8583172bedecc2646cc81ced31e5c952de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73c6937b54b78dfceb00b1a890b7e4c608a5157f646ea44286b3ae01c198288b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"

    # Replace code comment to build :all bottle
    node_modules = libexec/"lib/node_modules/cspell/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", ""
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
