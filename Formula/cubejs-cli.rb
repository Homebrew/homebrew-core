require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.8.tgz"
  sha256 "f737e961ce7643215e9c1561e86ef948708f9ccfbff2ee93122bd45b4ddb75f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06b5149b67f3d46e099883b291863194be6e6162e8de261603821ed21e5706c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "0839de3baa19011e3e68508ba73b086c098b6dc393683e4c6f05073006f18e8c"
    sha256 cellar: :any_skip_relocation, catalina:      "0839de3baa19011e3e68508ba73b086c098b6dc393683e4c6f05073006f18e8c"
    sha256 cellar: :any_skip_relocation, mojave:        "0839de3baa19011e3e68508ba73b086c098b6dc393683e4c6f05073006f18e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06b5149b67f3d46e099883b291863194be6e6162e8de261603821ed21e5706c2"
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
