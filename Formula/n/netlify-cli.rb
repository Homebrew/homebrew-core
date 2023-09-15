require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.3.3.tgz"
  sha256 "8439c78e83fc70ae3d32c4426e99187b2de681772b7259111f7ce619b675037b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "5e30184b998a612cf142d83e249649865f95e150e32a386cdb29dc35cbe8683d"
    sha256                               arm64_monterey: "4211f91782d23cc6f5c0b5b2d38dc73053900e7ca2c12829b9714e97c6a7046d"
    sha256                               arm64_big_sur:  "ab1ea440ae1f926307f7a8b4598bd8614fd2ba279d42d94c9f441f14bc552ce0"
    sha256                               ventura:        "30e1760fffc591e4207e1deac88d67a065771ee5e535fd378e959d0c4bd0be4d"
    sha256                               monterey:       "dfadce4b6397fdb9a9861f96a35784010f6c2e35d61be7bd671badbd51eedc36"
    sha256                               big_sur:        "250a8084cac750a01f3716ab66484d929c0d56f03b89a2c669330de5b84ee74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e98c7d691ff89913ebed4518f3bf1b7ba021e5c3bf8d878e61a59104f0040733"
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
