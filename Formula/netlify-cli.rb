require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.16.0.tgz"
  sha256 "41a721dcb30c5df5151efb6480aa5c04fa481ed7fabeefcb95d7d1a772d22d1d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06ffe927bffc5b3809e0ae40938374a7c3d2c7bdba5a7e202756ab720fd6cc47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06ffe927bffc5b3809e0ae40938374a7c3d2c7bdba5a7e202756ab720fd6cc47"
    sha256 cellar: :any_skip_relocation, monterey:       "edd395fcc8e4af56d4915779b7102784e0957b45bfef13bab3f4ec2df0daad28"
    sha256 cellar: :any_skip_relocation, big_sur:        "edd395fcc8e4af56d4915779b7102784e0957b45bfef13bab3f4ec2df0daad28"
    sha256 cellar: :any_skip_relocation, catalina:       "edd395fcc8e4af56d4915779b7102784e0957b45bfef13bab3f4ec2df0daad28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b8b7d07240df45086ed92fabf1b82eb71a9439aacce54ac7768de45fc5d32c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
