require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.11.0.tgz"
  sha256 "05b8e98100b4b09cbe9947b590f287c23096ba2aa1cc7ee471d707de951a8982"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "51e8383bae9b679aab1fa6074bd937c5809217ef54ad08912cc6f1e35a6624c6" => :catalina
    sha256 "3bec10843b5e7ec281406da08716010e506b2d1735eb92c2e8bf9e08f7f7b31f" => :mojave
    sha256 "9de5e68d590ac2a541940afa618b03b1c1c00f207d7b41f3c3da64d127f3674b" => :high_sierra
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
