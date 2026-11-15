class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.5.1.tgz"
  sha256 "8fd6f9f3f04af02fc94339e3846dc4ef2833aebacf115f47816b46c2a4c75e16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f897138c8ac77fac0c83d9b51efd498a3fb3ed77e271cd75e1fa11dd8006aae"
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
