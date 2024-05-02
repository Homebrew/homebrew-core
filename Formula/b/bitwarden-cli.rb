require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.3.1.tgz"
  sha256 "76d2e3857d4d25927f980869d9087fa810ba5ba284e0fd825de7ba0dd4be5942"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "234b7d7a360a02e1ac45223dbdb6c12e741b47f8e505c90c1634cca38e3b580e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb6b3648e8092836862b39a77f95a0fbe89133cef56b14d56be5246fc597d188"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c4d5a19448506a2cf19afc860dd7f709bddc6463b905aa095ab2c9cfe8c198d"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b41c879007266c830967f9c6e8c2ed06e8df863bdde6c12627b938dbaea8ec3"
    sha256 cellar: :any_skip_relocation, ventura:        "77558fdb9e8d2b69293fa48d502b85fe4477170d207a00079678d0e9c4ce17c1"
    sha256 cellar: :any_skip_relocation, monterey:       "09c5830ff1b3f97ad1be140e8f5f1859c03e042d60b8cb833684f016e6bbde2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdb847dc684abcda103c32d727d008ff065f2f1f238feea58786fb8a6a79d856"
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
