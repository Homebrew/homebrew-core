require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.3.tgz"
  sha256 "81858dbf81d7067a5128ff87c60d6f0046ba26a6649b5762f05c5d013e12131a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "962c58b198ad255203848afa9d2619506f4a38f2bc2e5b742c240bbdae7afc88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962c58b198ad255203848afa9d2619506f4a38f2bc2e5b742c240bbdae7afc88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "962c58b198ad255203848afa9d2619506f4a38f2bc2e5b742c240bbdae7afc88"
    sha256 cellar: :any_skip_relocation, ventura:        "0191775f0616ec0dd2a68e414f4057d6ff6fe73e8f0a56b24592ed22706627a4"
    sha256 cellar: :any_skip_relocation, monterey:       "0191775f0616ec0dd2a68e414f4057d6ff6fe73e8f0a56b24592ed22706627a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0191775f0616ec0dd2a68e414f4057d6ff6fe73e8f0a56b24592ed22706627a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "962c58b198ad255203848afa9d2619506f4a38f2bc2e5b742c240bbdae7afc88"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
