class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.1.1.tgz"
  sha256 "794e56ad342837285e4c2aa3b9907b50ff073febbbfb4550c0a613ee9981da10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9a8b193beaf864701005cf44a94ea4bbbd7874ff08e5a89b2f760bb997c85de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a8b193beaf864701005cf44a94ea4bbbd7874ff08e5a89b2f760bb997c85de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9a8b193beaf864701005cf44a94ea4bbbd7874ff08e5a89b2f760bb997c85de"
    sha256 cellar: :any_skip_relocation, sonoma:        "77989511b517e120e9158e04de87d6a99303a8afac48e39096280d82f7f068c2"
    sha256 cellar: :any_skip_relocation, ventura:       "77989511b517e120e9158e04de87d6a99303a8afac48e39096280d82f7f068c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9a8b193beaf864701005cf44a94ea4bbbd7874ff08e5a89b2f760bb997c85de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a8b193beaf864701005cf44a94ea4bbbd7874ff08e5a89b2f760bb997c85de"
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
