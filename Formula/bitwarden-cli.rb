require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.3.0.tgz"
  sha256 "6742121eb25b135e7faa309131e31c16f25cdc898d00c4cf75c6b1c27605e538"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d58f4fe3c69be8f53f7f1493a1b5576c297e947ae30e9938eba630c7757d81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a93a47effccea5fc79c0098b4c4ef06dcb4602535e3099dadd548c89375cc4da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8d30a231aeda4581ea1d78349632ec22f73e7194561400280750c76f93983d"
    sha256 cellar: :any_skip_relocation, ventura:        "698902f117596b4869cde73dea7c4a674ad35144c6beee10b36e13a279b2c7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "41984be7f863ccbc940e6f92a5da6ccd82fef5c9ea02ad67c7761d83fbbed2b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "a22d43cd17c566334a86fc0dc41ca40b359f9217b0f26211aa39680674aba07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85580baf4a456139c6ef6192019fd6eafa385daec24f6aa04c2df5f2a35918a6"
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
