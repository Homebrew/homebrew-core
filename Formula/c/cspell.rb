class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.5.2.tgz"
  sha256 "ff12c624f1b2b1ad2780e81279d333ac07ab8f4b3c24b44f1fd095020cdcae01"
  license "MIT"

  bottle do
    manifest_sha256 "1c6ed0acb0534986d1e11845ff1fe35c79d51d5620925b200e1bda179a9448ab"
    sha256 cellar: :any_skip_relocation, all: "83b0edd30d40e9489418fb4f7d55d2b5b2d99ce8ac8682dbd6bf3a2114be6039"
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
