class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.2.0.tgz"
  sha256 "f9281d9cc44c111f851f795e977e9d54b224968b13226741a6dfa9081df7258a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe25bb68f4c4cf638d80f1397502c040c7a7bdd766101012fd08be52e346c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe25bb68f4c4cf638d80f1397502c040c7a7bdd766101012fd08be52e346c14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbe25bb68f4c4cf638d80f1397502c040c7a7bdd766101012fd08be52e346c14"
    sha256 cellar: :any_skip_relocation, sonoma:        "215c04b90d64155597e7cb0ee37edebd85940c8120dcb151a7da727a343d08fd"
    sha256 cellar: :any_skip_relocation, ventura:       "215c04b90d64155597e7cb0ee37edebd85940c8120dcb151a7da727a343d08fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe25bb68f4c4cf638d80f1397502c040c7a7bdd766101012fd08be52e346c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe25bb68f4c4cf638d80f1397502c040c7a7bdd766101012fd08be52e346c14"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cspell --version")

    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end
