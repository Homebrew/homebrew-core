require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.39.tgz"
  sha256 "90665d89e6fdefea271c8836d105333fe3c97cd1c1bc8f1509ea0f708e831131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb3ae4f4ffb69b63b6a5bef9d13687531dad84c3774d45b65e7df25298226253"
    sha256 cellar: :any_skip_relocation, big_sur:       "c839f2b30f83338629920bd7c5ecd596c56ade368e1f43d4f0cd99d4f62a8345"
    sha256 cellar: :any_skip_relocation, catalina:      "c839f2b30f83338629920bd7c5ecd596c56ade368e1f43d4f0cd99d4f62a8345"
    sha256 cellar: :any_skip_relocation, mojave:        "c839f2b30f83338629920bd7c5ecd596c56ade368e1f43d4f0cd99d4f62a8345"
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
