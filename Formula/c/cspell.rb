class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.6.0.tgz"
  sha256 "a1076eb700496033bb9b4bde98b689f0119ccb16d018652707156277fe50cf4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd104c6de0e90fcbb81cb953c26cf0af74bf0d7299775dc970454cf087dec88d"
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
