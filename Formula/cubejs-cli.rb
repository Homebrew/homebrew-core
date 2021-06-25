require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.42.tgz"
  sha256 "5c4ddc7d4853eb35138c47fb52640cd5508f183266a3abdd7068f9c2c7fd02e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4dcfdec8b951c66011a7c015bd293c579bc4f0637af3fc2c36abcc06084f65b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "10717152de04e5a2dd986c0745428b7d6cb5729b59ff9f7476221415f1a2c9a4"
    sha256 cellar: :any_skip_relocation, catalina:      "10717152de04e5a2dd986c0745428b7d6cb5729b59ff9f7476221415f1a2c9a4"
    sha256 cellar: :any_skip_relocation, mojave:        "10717152de04e5a2dd986c0745428b7d6cb5729b59ff9f7476221415f1a2c9a4"
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
