require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.61.tgz"
  sha256 "1e679112bf54dab17624797db3fde95fa4beb159bee67904383d8489a41e5477"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "73b6dc98329b30a487b0e3692a2575aea3588e78e2c78c4edbeeeca29bb23e7b"
    sha256 cellar: :any, arm64_ventura:  "73b6dc98329b30a487b0e3692a2575aea3588e78e2c78c4edbeeeca29bb23e7b"
    sha256 cellar: :any, arm64_monterey: "73b6dc98329b30a487b0e3692a2575aea3588e78e2c78c4edbeeeca29bb23e7b"
    sha256 cellar: :any, sonoma:         "c974d87a4f326f67b624939cdb210cd680d403eb72b6f2b8c448237088c8be71"
    sha256 cellar: :any, ventura:        "c974d87a4f326f67b624939cdb210cd680d403eb72b6f2b8c448237088c8be71"
    sha256 cellar: :any, monterey:       "c974d87a4f326f67b624939cdb210cd680d403eb72b6f2b8c448237088c8be71"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
