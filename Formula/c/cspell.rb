class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.1.1.tgz"
  sha256 "794e56ad342837285e4c2aa3b9907b50ff073febbbfb4550c0a613ee9981da10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7569e790a0992b229a479822217fa8b7d410caefd0dd00357508b1d77ba85032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7569e790a0992b229a479822217fa8b7d410caefd0dd00357508b1d77ba85032"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7569e790a0992b229a479822217fa8b7d410caefd0dd00357508b1d77ba85032"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af48d108e33d112185817f57034dbb2f69e769b6cfaf935cbf90c3e8c70132c"
    sha256 cellar: :any_skip_relocation, ventura:       "8af48d108e33d112185817f57034dbb2f69e769b6cfaf935cbf90c3e8c70132c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7569e790a0992b229a479822217fa8b7d410caefd0dd00357508b1d77ba85032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7569e790a0992b229a479822217fa8b7d410caefd0dd00357508b1d77ba85032"
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
