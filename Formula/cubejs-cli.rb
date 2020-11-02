require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.5.tgz"
  sha256 "1aa7e732297bb9aa08a168f24b5d8988a0627eef74d760e5a304d3803844562a"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bce92390c85d053a0b7682a22d5cd8bef875ce0a9ba9db1159e208b4c49d3226" => :catalina
    sha256 "74310bd38d7791874fe81db47f2d9acd5be0b92be04f65dcb321668654ae5210" => :mojave
    sha256 "faa5e51b009142cf416ecf906987c14a9c24a967b48fe96c30404cd8341ae72a" => :high_sierra
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
