require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.7.tgz"
  sha256 "bfa9baf82de7b3f3ab92246ee1a251893a8170ce16b9205e8abb5dc945a6b74e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5955e0b5ad403f0196870f4f28c51d2fcc3c5069b918bae5da47b75a58f4deb"
    sha256 cellar: :any_skip_relocation, big_sur:       "975e663775e8837084b5237ce4cf47a72b46514862851930e1e937ddc5fbfa84"
    sha256 cellar: :any_skip_relocation, catalina:      "6af79b0e93c3a3d8764a1b48d81a9d1d134a79998d5f508715d7961e62f7f39c"
    sha256 cellar: :any_skip_relocation, mojave:        "4abcf0947b9752c65da076b8c52e5a75396cfc1951d8b5fb272aa1fcf386fea1"
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
