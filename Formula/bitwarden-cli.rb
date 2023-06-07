require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.5.0.tgz"
  sha256 "1e9a592ed4ae1611afbd652ee546fd95b2bbf8414a02db836d756ee653ed2321"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1117caa3a277145ae126a54f52b4242b467ad9c7cad2ac530a667676d94bc13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031b76b04068b9fec4734d2a9da44083f337e262f19cdc4671f491e5698d5d8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66038993f6750bcb6fb22fcdd088d4f9470f09abd8eadfddbe6212cbcab3a2ae"
    sha256 cellar: :any_skip_relocation, ventura:        "2a94dd9a98631f278881f58cdb43bdb80d0bb1de738ca3609ce8d481af1f9667"
    sha256 cellar: :any_skip_relocation, monterey:       "c85aa45929292e966a128fd97da818e3048b9abf90b2c2d2748314e238a0791e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee10ad1178321c92758ec66a870cf659bda23c5ad558075c89255b9bc97184a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18fdd536c14d66765732faf87afa773be7e112f7c9f695cdd06cbb854347414d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
