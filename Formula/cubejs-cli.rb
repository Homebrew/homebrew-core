require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.5.tgz"
  sha256 "75e7263d993cdf1935617ab8b4d29a8df9774bf3bb7e40ea77e72fd3902ecadc"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8965b5a47998e138c93db639c996f99b9ee907b58affc1949709fb5d80be5efa" => :big_sur
    sha256 "3b65e21e1c712ed6d1fff64f918b93b37803be42cb2cf43b5931c994ea31db70" => :arm64_big_sur
    sha256 "9275c653ec141838704f0c608161889f579d22b8f25ccc55fbf89b44b3bcf37d" => :catalina
    sha256 "417facd4953bad483a202febf6fb2f443965ecfff3695dd73ac5534d93c8df36" => :mojave
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
