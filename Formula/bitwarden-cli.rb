require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-1.17.1.tgz"
  sha256 "761f94c5ef86dbe584e28aaf8c1b452098befe5405b6192256e881884c242169"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a33f50a1759e1c132d0747ad3e8f03e97d66d8207bc8192b8a1dc018910a614"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, catalina:      "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, mojave:        "5bc2d8ce3bb4fc801cfbe0406014811d745132ea58abcf22e07eae13ce333b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39271a6b8270b3e219cf5df9df343ba7c68a6b71bd48cf8bf1c37d75c53742d6"
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
