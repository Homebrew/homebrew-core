require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.3.0.tgz"
  sha256 "4f5389a6be4c83f08e22199788b7a228e5013d57d2146c80cb4bc2249f4e1bbe"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c2fbdf2b717e07649ebad7dc90f8fc0459454d3400ed214803acd40866a3bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39c2fbdf2b717e07649ebad7dc90f8fc0459454d3400ed214803acd40866a3bf"
    sha256 cellar: :any_skip_relocation, monterey:       "37136a87310edcf7a57ec11eeb8af51f5c2ec2a13344923eb8e9ec119be51518"
    sha256 cellar: :any_skip_relocation, big_sur:        "37136a87310edcf7a57ec11eeb8af51f5c2ec2a13344923eb8e9ec119be51518"
    sha256 cellar: :any_skip_relocation, catalina:       "37136a87310edcf7a57ec11eeb8af51f5c2ec2a13344923eb8e9ec119be51518"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5783df67bca272e66d55094ad45c688c1ff8407a92be6eaa41ca077996a9d105"
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
