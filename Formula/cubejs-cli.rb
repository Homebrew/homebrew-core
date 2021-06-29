require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.44.tgz"
  sha256 "8cae0c7f8bb6f44fe86cd34386fa29e3d73638c46bd89b7ba6056c59d70a5716"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45ca50e0f885859e39e172762331c965b255bd55179dc6aa4426b0d001350866"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cb2e246565db46b1af6ec633ce59a68696ef38b4a365525f2093fabeb8132f4"
    sha256 cellar: :any_skip_relocation, catalina:      "9cb2e246565db46b1af6ec633ce59a68696ef38b4a365525f2093fabeb8132f4"
    sha256 cellar: :any_skip_relocation, mojave:        "9cb2e246565db46b1af6ec633ce59a68696ef38b4a365525f2093fabeb8132f4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
