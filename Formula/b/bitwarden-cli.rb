require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.2.1.tgz"
  sha256 "cdcf04bfb3273d6a0b70e88ace52d4f1ed42cc70a464f11838b8ea7b5a8e3d7f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca889898632f816748d97eee49164b53c3d505591856ef5ab8596c811424d5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00fa9d562a0043b9b018f2654f40f514f865d70104d0544857bff0a156078387"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645542d699ed32af0ded88ed10318519a1f48fe171bd534756411da7f896bf80"
    sha256 cellar: :any_skip_relocation, sonoma:         "092b63e812971561789ee2e40c3b2c69819e9bfc1f1ba443636e84f4f5f61bd6"
    sha256 cellar: :any_skip_relocation, ventura:        "fac1300450c4100e550bc63c5e49199cae201ac2af2c8d96f1d52c755bb49809"
    sha256 cellar: :any_skip_relocation, monterey:       "6cde4b01d92376dc4d612da24d7d12ddd554bd2e8349b3ebbca15d0f0fa3cfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f811d6cecded89fc4b03b0f0a49778fce05adfd911e7daef5d018ca7eb1011"
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
