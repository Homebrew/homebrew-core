class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.6.4.tgz"
  sha256 "a4868f122883df15f27b2f8c1888583e5424c38da62910f3a5e5b3100abeb2c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ded4d5c99113a64ed17a34b8d267dc699bd097bb56ba33ccd3a2e31fb2455f46"
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
