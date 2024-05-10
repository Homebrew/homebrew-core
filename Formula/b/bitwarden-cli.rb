require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.4.0.tgz"
  sha256 "2e359ce4e682b900306897807f360c2a39dcf03afd0bdedfffcc8bfadb87e5e7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9c11abded3190098bc8d57a813a7cb17dbc3b058be7018325744ab5502be35a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54bab3a978ae8d64f1e604d7813a3b56da33bec6c871e061adecd66b22743802"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a77830054daedc10ff96e84371ef4893740b1903bb72ad5e04f06dd2f967cdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3b6c5533e4c83ebf0dbde18171f13b05fea2efe95b70e78c253286469ec6745"
    sha256 cellar: :any_skip_relocation, ventura:        "896479abc3a62392f00775f145ff43f83e76debb4fd09d98c2d640094ad433e9"
    sha256 cellar: :any_skip_relocation, monterey:       "b1b9114015995c1f9745c778efd91d12bdf24cf594fe73acf6c779df51f44165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15ae0b8f064cab684985e773d8d4a371320258a9d36991fbd1685d98cd5e782"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(
      bin/"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
