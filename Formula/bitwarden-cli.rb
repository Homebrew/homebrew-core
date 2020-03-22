require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.9.1.tgz"
  sha256 "2ea78b25899b54a343669f30779f464a186ab53c3f9856961e58e33312a0db2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "924f41a76f269aca83fda99b64e89d25736fa629dd14c4fe047ef77941b9271d" => :catalina
    sha256 "895cd1b27b75252b6fefe225bb32a52ee536673198c8c9c9d8be769e03b901d8" => :mojave
    sha256 "62bc0147225c790b55e896a41366ad4d134cfc7596a3993c1124e07b35455a32" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
