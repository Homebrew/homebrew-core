require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.7.0.tgz"
  sha256 "d9f23fb967d4fb625031396026a2423298ac43a41c99e6043ea156278d243db8"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2828cbd31326690c1418340c017ef47c329d566c9046fd2ffadc32c4706a5da3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b99cddb377441608dcb8ed6ed825ad1b625ad36fee4d9a90a61461b7a683e7c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8341dbe751be579794706a899e9a0303a388f6dac549aa9fd251827f4cf0acc7"
    sha256 cellar: :any_skip_relocation, ventura:        "5dfbf48db3b5ad6d890fb6a3dada040a018d31ab2fcf08510b001e6baaaf37a3"
    sha256 cellar: :any_skip_relocation, monterey:       "197b3d117f56462be03d33bdf49dabc9d29910898c97602233e071925f929218"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd3118bf2d165cd737fd2b44d7833da01bfa72f1f9539d51c1bef1d29408ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c0518f5ce8f908145607105706803eeca4a2caa08cd372dc2bd18e371b21f5"
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
