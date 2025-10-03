class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.6.tgz"
  sha256 "d50e7b083f235346c0b9b2a3a7c4985bf4f3f2ddd87d528e07a28859aed1045d"
  license "EPL-2.0"

  bottle do
    sha256                               arm64_tahoe:   "d9a7b92f30e129532d003c31b98ba86efc31ee0f2d5eb2fc4a6dfccd829d2b42"
    sha256                               arm64_sequoia: "21fda98823a6dc025e0a0e747d7035bdbdfb2bac339a33fdd92cc9faf3e53ab2"
    sha256                               arm64_sonoma:  "f962ec113990e460707a443e6918f1a7f64d33b69eade644673875fb1376ffca"
    sha256                               sonoma:        "e1652231f028b1c9c91c8143f6f3c6cd560b680391d2ef38dc5b2d98b789b640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4013676dbca2fec57fa5cba652a53aa375532afe4b07f9ae106db75a2a9bd3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9092529f7724d6169b014570bff62ab784ef2c66a819ff8da62fd227059b2e5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
