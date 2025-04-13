class GitterCli < Formula
  desc "Extremely simple Gitter client for terminals"
  homepage "https://github.com/RodrigoEspinosa/gitter-cli"
  url "https://github.com/RodrigoEspinosa/gitter-cli/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "c4e335620fc1be50569f3b7543c28ba2c6121b1c7e6d041464b29a31b3d84c25"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b7c17753a1b4e92a83ed41e22b7ff595cc2d2165d1fa95f0808109605f45c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59b7c17753a1b4e92a83ed41e22b7ff595cc2d2165d1fa95f0808109605f45c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59b7c17753a1b4e92a83ed41e22b7ff595cc2d2165d1fa95f0808109605f45c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "74f47c77f30e1b1cba0cac9a53221463728ea01f5b7e17b4bccf58795f3b08df"
    sha256 cellar: :any_skip_relocation, ventura:       "74f47c77f30e1b1cba0cac9a53221463728ea01f5b7e17b4bccf58795f3b08df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042e9e513066ae7fbe936c1300bcd5ab6fcf7b51a19b2da93e64b3aaf5006ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b7c17753a1b4e92a83ed41e22b7ff595cc2d2165d1fa95f0808109605f45c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "access token", pipe_output("#{bin}/gitter-cli authorize")
  end
end
