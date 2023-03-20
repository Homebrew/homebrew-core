require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.2.0.tgz"
  sha256 "24d4e3bf51e76e80e98a4a1943593b0f9e3e789b64660d680c2e1fab148ac373"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb370700737923d21f8cfc9e64efcd7959648834eafe0fdac00131f490fce5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f3e1e1a739d837c6701a2658f4a29f15b9593a8a788e89cf8734ff150ad474"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230d1faae76e7d8f409e30184ff8697c464fac4b8f73a2277d9044042550a56c"
    sha256 cellar: :any_skip_relocation, ventura:        "eccfec7c0b0a9f4fb94c36189d9c0cb2d2383fbc77d6f97af2f07a38a8048e7f"
    sha256 cellar: :any_skip_relocation, monterey:       "063ebded1451260c2e38652b98f5a49316da1201b28049b8802f2f449f7c9567"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f16d56d5d845d43eca130dcb876162ad1cba9224b4c4a69b523dfc03ed69400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25db80452b26cd7a7f0651de1898faa24a0d96346de6c1cb9012811741a4048a"
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
