class BitwardenCli < Formula
  require "language/node"
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2023.12.0.tgz"
  sha256 "7706a7247915dd1f46f6cabd92c9d858372a0222e2ca834bab957f6ae437f451"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d430197eac1e0179e4b8849f452ab14446fcd53cdb1f453416ecc20f660e6689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "907826efaba78569dfcc32bc0653761568be86b1762e0808822c5522eef7361a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce719e1aef48a6507522e7b4c9fce451f0a39cd5a0aebefb4c293b62f76d9f97"
    sha256 cellar: :any_skip_relocation, sonoma:         "074a12c26932bd50ef9046508b01477d75eea828446e62340f1f879653578176"
    sha256 cellar: :any_skip_relocation, ventura:        "48f0ba57b6c4d9879908aa6e8d63cbb2b6e2c8cc21b581e0ee36772058ddcb44"
    sha256 cellar: :any_skip_relocation, monterey:       "2343bf577b332280956e77e05383bfa2f303210f5ab88acfee7f35bac123d94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f46a258f8bebbef5b3f0620646c2c347e02f992e6b5fc584a01c2f8aa31ce3cc"
  end

  depends_on "node" => :test
  
  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(bin/"bw", "completion", shell_parameter_format: :arg, shells: [:zsh])
  end

 
  def caveats
    <<~EOS
      Bitwarden cli requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
