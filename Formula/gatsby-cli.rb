require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.19.0.tgz"
  sha256 "7199c4314732c1723618522f6f60c0e4f154688034b05cfb40f09ad6b9acd7a7"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a7bf6b93e82cb29d95258e875739a9fde3f1d4be0646ffe61ae81fce9d705a92"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6400a53542d40bedfb1db250e90916027cd99880fc0646f08f53ff9106b159b"
    sha256 cellar: :any_skip_relocation, catalina:      "6c22ef7ae646f78a284c3d0e43bd3b8372054c84aef3cfcf930a61671bef5bbb"
    sha256 cellar: :any_skip_relocation, mojave:        "b3d90b7351d0e3910def451c988b7ec7001415000c0463bd2af63952c7e63c0d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
