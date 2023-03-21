require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.11.tgz"
  sha256 "7f5ea9f8341c06d9fb4acd741846f2aaca1379e2638919f2c1d823c1b3b17ddd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe8bee07e94ddea28717eb8f4180dcef7d3c18f5ebd6369d2b59af4a684efae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe8bee07e94ddea28717eb8f4180dcef7d3c18f5ebd6369d2b59af4a684efae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe8bee07e94ddea28717eb8f4180dcef7d3c18f5ebd6369d2b59af4a684efae8"
    sha256 cellar: :any_skip_relocation, ventura:        "33c844cac0e82c00139c48967a0c177fe5034583cf6414cc6bbd9e41072108e9"
    sha256 cellar: :any_skip_relocation, monterey:       "33c844cac0e82c00139c48967a0c177fe5034583cf6414cc6bbd9e41072108e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "33c844cac0e82c00139c48967a0c177fe5034583cf6414cc6bbd9e41072108e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8bee07e94ddea28717eb8f4180dcef7d3c18f5ebd6369d2b59af4a684efae8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
