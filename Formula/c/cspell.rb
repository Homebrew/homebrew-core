class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.4.0.tgz"
  sha256 "73b8354d9bf11df027d08283848f67fc45fae15bdad804dd741ef6ffc1b22ac2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d43d0115d6c277878651f9b48f5e671a9fe2b9bd3af66050842fe186d6c7dc65"
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
