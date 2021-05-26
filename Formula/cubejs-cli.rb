require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.20.tgz"
  sha256 "f0c005ff8b5adf3d18f61789552e682971e83755134436874eecc0bbf3192ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b712a00df6586ad667b6516cb2ce95751ce57beb7555314d164c226097e7523c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0b4afbfa954e55d057cf3ca52c5228075f5998ad75462be3517e8ac881c8eef"
    sha256 cellar: :any_skip_relocation, catalina:      "c0b4afbfa954e55d057cf3ca52c5228075f5998ad75462be3517e8ac881c8eef"
    sha256 cellar: :any_skip_relocation, mojave:        "c0b4afbfa954e55d057cf3ca52c5228075f5998ad75462be3517e8ac881c8eef"
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
