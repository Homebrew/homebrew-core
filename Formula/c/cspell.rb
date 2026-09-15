class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.3.1.tgz"
  sha256 "36983fd2c2c55df6465c451dc239b51a755a209d97d26f339b55d024ce792692"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fe009fb3d413292e6b0baef66f4950df1d2b5a076b0239f33ec870b1e76bce19"
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
