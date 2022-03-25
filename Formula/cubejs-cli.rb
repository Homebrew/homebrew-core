require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.35.tgz"
  sha256 "d458687672786403a9f72c3771684b70adb9b9ec65cd05e2ae8b66cab6cf5bfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "059a17aac4837365dcb45470b9e5133853816de31ebbac615f5b846f691f031a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "059a17aac4837365dcb45470b9e5133853816de31ebbac615f5b846f691f031a"
    sha256 cellar: :any_skip_relocation, monterey:       "7349741a01d3e675c2ab65d21e98a1f1b7cd9fb0d07479db2c67ce0e41795943"
    sha256 cellar: :any_skip_relocation, big_sur:        "7349741a01d3e675c2ab65d21e98a1f1b7cd9fb0d07479db2c67ce0e41795943"
    sha256 cellar: :any_skip_relocation, catalina:       "7349741a01d3e675c2ab65d21e98a1f1b7cd9fb0d07479db2c67ce0e41795943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "059a17aac4837365dcb45470b9e5133853816de31ebbac615f5b846f691f031a"
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
