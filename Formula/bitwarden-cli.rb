require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.2.0.tgz"
  sha256 "24d4e3bf51e76e80e98a4a1943593b0f9e3e789b64660d680c2e1fab148ac373"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5003c94ebc6f68b58c635a53d7faae01b3c8f3662139a8ffef10d7fd0fa60c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5003c94ebc6f68b58c635a53d7faae01b3c8f3662139a8ffef10d7fd0fa60c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5003c94ebc6f68b58c635a53d7faae01b3c8f3662139a8ffef10d7fd0fa60c4"
    sha256 cellar: :any_skip_relocation, ventura:        "e7dd69a2be5f17dad5cd31849fcc7351f4bce8ae1f413be89446f56bbab16372"
    sha256 cellar: :any_skip_relocation, monterey:       "e7dd69a2be5f17dad5cd31849fcc7351f4bce8ae1f413be89446f56bbab16372"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7dd69a2be5f17dad5cd31849fcc7351f4bce8ae1f413be89446f56bbab16372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5003c94ebc6f68b58c635a53d7faae01b3c8f3662139a8ffef10d7fd0fa60c4"
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
