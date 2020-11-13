require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.13.1.tgz"
  sha256 "da58b260a4d517ed371ca28c3a3c4b44b8cdd57f186cbdf04d6ed28b10e6e721"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "05083e62dc125662f5a19765dc1a8721dfcbd161f77b7a75a0196e43a89f8f46" => :catalina
    sha256 "ecf7d13078fb366613cdfb8bde52610b03fecced474bc52ee2d30ad0faeb7461" => :mojave
    sha256 "b4dc63d64afaa3d36a50f6c46acc1b4131111c3999de99bbbc115319e33e7448" => :high_sierra
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
