require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.8.2.tgz"
  sha256 "faa7fa3f2fc36de1e2fa3672bcb2bc25efc4d5d834e213f0e60af52487b4905f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edde18a365a4c4e4b09421ae44673bd254f57bc1b331bd3b721aed7817ff9516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8c4378f5dbf9979474fa27847c83d2de754e7fe9114c4546d95630a6fc737be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec48b34ee51ac7148b190cf2d5a1df80fcf483dc828054d6acfd6fd780a9526e"
    sha256 cellar: :any_skip_relocation, ventura:        "b67eb228c277b726c64b00729018e06e020d24892b0b194451ee199c1382c131"
    sha256 cellar: :any_skip_relocation, monterey:       "16278177c7c11cd0d58d06f19f4b4e34fb199ea01f1f1daa3e9f8f103ff95c42"
    sha256 cellar: :any_skip_relocation, big_sur:        "460e1c279984406652724a7520db91deaac7b90aa48c37e1797a96b14308e0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "688ec47af55ceb3585c937cbc71b7f775ae00fd251b185373c174fcf43edee1a"
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
