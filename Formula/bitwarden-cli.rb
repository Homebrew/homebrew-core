require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.0.0.tgz"
  sha256 "75475a7eb9c728b0b16c1a69d397391019617cfbf73304bcc8724d9fd32aec47"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    version = shell_output("#{bin}/bw --version")
    password = shell_output("#{bin}/bw generate --length 10")
    testingb64 = pipe_output("#{bin}/bw encode", "Testing")

    assert_match version.to_s, version
    assert_equal 10, password.strip.length
    assert_match "VGVzdGluZw==", testingb64
  end
end
