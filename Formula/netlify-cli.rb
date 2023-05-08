require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.0.0.tgz"
  sha256 "1e7f2501208b924e740ea9848083f0d19a8647dbc34a78d0954be18440a79565"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "f9fe7244e697783f45bf71bda51f3a6ca568724f9ef40402c402b42f75d918f8"
    sha256                               arm64_monterey: "e52b1a4df9eec63b567cd47ea77844883335fed9950816d410446a8eb529bb3e"
    sha256                               arm64_big_sur:  "4937888792b912f49d7fe3c5a269a3221418a8a36df8496571b85a591fccf1e8"
    sha256                               ventura:        "0c3dbf03bc5d2b406d62b7171f50032282861ddf84093dbc64ff04646a5702ac"
    sha256                               monterey:       "2b137d12547e007eef8b00da2d9ec273d7a1715e1b39d9f825198f0c3c9f6de1"
    sha256                               big_sur:        "6339d905ebab73f1dad77685766a5e311481220dfcb765ad5d7f167ba10b0717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c25a24f4c7b79a340d6b51b8661bf634e2296ea51ba383ff1259a54a4d4571"
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
