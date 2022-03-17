require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.22.0.tgz"
  sha256 "6c05e7d31d6c885d43aee8370bbb50691ea07ae379b818ff2c90ebdcbf9363ac"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba825bf27c939461b40b356468770c3a8f728d69a9bc5edad54977cd8cae1e61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba825bf27c939461b40b356468770c3a8f728d69a9bc5edad54977cd8cae1e61"
    sha256 cellar: :any_skip_relocation, monterey:       "5affceea59e0c73765175f9de64b9822c35fd8f7c26dcb21cc970776fa955aba"
    sha256 cellar: :any_skip_relocation, big_sur:        "5affceea59e0c73765175f9de64b9822c35fd8f7c26dcb21cc970776fa955aba"
    sha256 cellar: :any_skip_relocation, catalina:       "5affceea59e0c73765175f9de64b9822c35fd8f7c26dcb21cc970776fa955aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba825bf27c939461b40b356468770c3a8f728d69a9bc5edad54977cd8cae1e61"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
