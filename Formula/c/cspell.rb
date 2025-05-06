class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.0.0.tgz"
  sha256 "ad48d250caa44adc14384c467080bfd08562884fc0aa9fb206d78b7270a93d4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2a4b9ffb95f8abb0637928b17b06901e165d7c7a5e1da4154d53e15e604ec2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f2a4b9ffb95f8abb0637928b17b06901e165d7c7a5e1da4154d53e15e604ec2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f2a4b9ffb95f8abb0637928b17b06901e165d7c7a5e1da4154d53e15e604ec2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe728cae807e9ebc4b931790f51e7c69f9b7c029f5ba33f4fb3036b3ffe87663"
    sha256 cellar: :any_skip_relocation, ventura:       "fe728cae807e9ebc4b931790f51e7c69f9b7c029f5ba33f4fb3036b3ffe87663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2a4b9ffb95f8abb0637928b17b06901e165d7c7a5e1da4154d53e15e604ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f2a4b9ffb95f8abb0637928b17b06901e165d7c7a5e1da4154d53e15e604ec2"
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
