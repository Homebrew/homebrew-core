class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.1.5.tgz"
  sha256 "625caf6c4f05a20b658f5def8c6e3291fdddf6782bda7a3055917d21890561af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68adfecc629084f042eb4e33321a6b311be5a46225d2ba60dc82eba6a09751ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68adfecc629084f042eb4e33321a6b311be5a46225d2ba60dc82eba6a09751ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68adfecc629084f042eb4e33321a6b311be5a46225d2ba60dc82eba6a09751ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a8a3368aeb476dff91224d0b6e1162cc3a18f515cba83497371f999d30dd4e4"
    sha256 cellar: :any_skip_relocation, ventura:       "3a8a3368aeb476dff91224d0b6e1162cc3a18f515cba83497371f999d30dd4e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68adfecc629084f042eb4e33321a6b311be5a46225d2ba60dc82eba6a09751ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68adfecc629084f042eb4e33321a6b311be5a46225d2ba60dc82eba6a09751ea"
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
