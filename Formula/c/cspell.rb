class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.2.1.tgz"
  sha256 "6573684309ab082140064a96e9a37f39f876e48a5ef308891a77513e9e32cddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d52035ce940e0246940b157e4ffb887979876e6b95def3d3606626fde7193bc5"
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
