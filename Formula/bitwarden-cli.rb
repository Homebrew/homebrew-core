require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.9.0.tgz"
  sha256 "47a324fc0c9d91e0661182182f6b33947d9c9f3f445c8b18893f114b10a83bef"

  bottle do
    cellar :any_skip_relocation
    sha256 "667f22080070882c2f80dd96f84a1508607a9f70df16c6d821ec9fe2e62b7e00" => :catalina
    sha256 "0e6dee9b113529bfc68cc57b0d274493e70f4e4c8528e80aa1c9dd06378649bc" => :mojave
    sha256 "dd3b0b6ea71a3fe76f2f263197f0116d62d60df1cac09a563072913bb90b0cbc" => :high_sierra
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
