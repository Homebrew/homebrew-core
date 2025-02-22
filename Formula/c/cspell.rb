class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.17.5.tgz"
  sha256 "8f2eabe7948718bc5b0833fdd68e4cf304140ecbc3ec501a7a59795a2ecc5861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f12d9b9a2a527982dede9b519534c0c6d5ab204882e2ed2d47178e80b6ef58c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f12d9b9a2a527982dede9b519534c0c6d5ab204882e2ed2d47178e80b6ef58c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f12d9b9a2a527982dede9b519534c0c6d5ab204882e2ed2d47178e80b6ef58c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e67f015130e4228d41e2e1b800e9f4a5008a76f10a5417072c62f6ed824220"
    sha256 cellar: :any_skip_relocation, ventura:       "b3e67f015130e4228d41e2e1b800e9f4a5008a76f10a5417072c62f6ed824220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f12d9b9a2a527982dede9b519534c0c6d5ab204882e2ed2d47178e80b6ef58c"
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
