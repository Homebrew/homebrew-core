require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.5.tgz"
  sha256 "a8e90b828e33160c6a0ac4fb11231f292496e8049c0dac814e46fdd0c90817c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e3c41671b0b6c453ad948118263f7a089943033d8783e645a8012c748c879cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad8728e8e6ab40ea7a850cacbe732ccf45bdf413023a9f2d053c8f704707a019"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8728e8e6ab40ea7a850cacbe732ccf45bdf413023a9f2d053c8f704707a019"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad8728e8e6ab40ea7a850cacbe732ccf45bdf413023a9f2d053c8f704707a019"
    sha256 cellar: :any_skip_relocation, sonoma:         "009993faa4cb9d7a197625d1a48179560a65b4e9ad9fee9ef0a82a51a989d43e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ef92b38dab30566604d6ac2af7c720e413b3a441620926c12d0cd04150afb11"
    sha256 cellar: :any_skip_relocation, monterey:       "6ef92b38dab30566604d6ac2af7c720e413b3a441620926c12d0cd04150afb11"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ef92b38dab30566604d6ac2af7c720e413b3a441620926c12d0cd04150afb11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83b92a41c3b7628440739661039bc4b6fc82628e266c322d5b389a094af0b3b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output(bin/"gtop 2>&1", 1)
  end
end
