require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.5.1.tgz"
  sha256 "01e22542c9363f1cdd2e5fc28727c37f513b4ac50662b92dd1e14a86efdf7acb"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "0b13aaf17edaa6863faa61215bccdb8c1db9fb24350a3c84604437235d0ccc84"
    sha256                               arm64_monterey: "8a5d9b3cc8fbb89656252874a4bb818215fae3fc37ef2c8f9698e2edd1dd8121"
    sha256                               arm64_big_sur:  "fbb701b0c61ad2bbbc3aa0a4b48cdba1b35e88caa130d40acf31778d915c2573"
    sha256                               ventura:        "9a80fca84327e0969f3dd2abe632c81f5396bedb31381472183f92e4fec63da0"
    sha256                               monterey:       "f8a7b8afa739987ac107818273d7b76afb60d9e76d125146b2fc515a4c91b6ce"
    sha256                               big_sur:        "7434d9d8efb760fddb13ce0a752689aa8ef16395b60bf92ae43ce5fa61ffdb08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "203c421030de3d981e0ec2f632c4ab7ce7e443ae28fc8ebb87b2ad295b1933dc"
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
