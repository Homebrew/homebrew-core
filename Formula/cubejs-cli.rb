require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.40.tgz"
  sha256 "caa7c210cf588ae1e945d9d9d394deb450b807f127ceb2f6fc0497a10c0daea2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d0cbd875dca4669374a31f361e90b10a9d9ff8dd3714a53224e08d7bf3a3aec"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e466752b49282978edc64411287ae172c373a68b87fc17edda4859c993044e2"
    sha256 cellar: :any_skip_relocation, catalina:      "6e466752b49282978edc64411287ae172c373a68b87fc17edda4859c993044e2"
    sha256 cellar: :any_skip_relocation, mojave:        "6e466752b49282978edc64411287ae172c373a68b87fc17edda4859c993044e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d0cbd875dca4669374a31f361e90b10a9d9ff8dd3714a53224e08d7bf3a3aec"
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
