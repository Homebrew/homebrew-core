class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.1.0.tgz"
  sha256 "c96e9596a1b8686319232d4157f8cfd984a5cdbbba51829fb5e46c7598066771"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9aef501c8a6763dacfc1eb0a34cbaac0065ba950f60affb94d512041f792e5a6"
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
