class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.4.0.tgz"
  sha256 "72a026eaab0f22f214370c24c3dfbe4962ae6eb78e493e8975a41fabff530b1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06d1d5abc8fc791d82f1853162baf2974b169995e50a02be2164cdd735625e56"
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
