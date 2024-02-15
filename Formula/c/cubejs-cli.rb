require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.55.tgz"
  sha256 "305449108d73109474c4158f242af43bb7d7991073fcdb199cd769d8b4449aad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "49305036cb722095b9f1b70e219828d7ff873575093caa19a7ed6c246563fb2c"
    sha256 cellar: :any, arm64_ventura:  "49305036cb722095b9f1b70e219828d7ff873575093caa19a7ed6c246563fb2c"
    sha256 cellar: :any, arm64_monterey: "49305036cb722095b9f1b70e219828d7ff873575093caa19a7ed6c246563fb2c"
    sha256 cellar: :any, sonoma:         "5f63dcfd4715b3308a75811d2fa14877b9f508544da898f6fc55bdc43b8bd0a6"
    sha256 cellar: :any, ventura:        "5f63dcfd4715b3308a75811d2fa14877b9f508544da898f6fc55bdc43b8bd0a6"
    sha256 cellar: :any, monterey:       "5f63dcfd4715b3308a75811d2fa14877b9f508544da898f6fc55bdc43b8bd0a6"
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
