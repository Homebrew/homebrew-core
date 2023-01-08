require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.36.tgz"
  sha256 "5a446e41ac601457b2104efc411c14602eca38b5f20220068cdc556bf8d379fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c17a547116c92e3f3ebea5fd13aaf3bc05e9cbef3aa28e73b0beffb0989153d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c17a547116c92e3f3ebea5fd13aaf3bc05e9cbef3aa28e73b0beffb0989153d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c17a547116c92e3f3ebea5fd13aaf3bc05e9cbef3aa28e73b0beffb0989153d1"
    sha256 cellar: :any_skip_relocation, ventura:        "ef318a3fc6d06f4b29efc5fa825d3d44fb0439854a3e5f8c6ad689162fdcade7"
    sha256 cellar: :any_skip_relocation, monterey:       "ef318a3fc6d06f4b29efc5fa825d3d44fb0439854a3e5f8c6ad689162fdcade7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef318a3fc6d06f4b29efc5fa825d3d44fb0439854a3e5f8c6ad689162fdcade7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c17a547116c92e3f3ebea5fd13aaf3bc05e9cbef3aa28e73b0beffb0989153d1"
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
