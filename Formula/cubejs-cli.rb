require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.43.tgz"
  sha256 "c073b4e7a9c33c1ec67219dd9f146b619770c2dc7d8bccd35e0cb2805651a1d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d805874ee4affae3fe607f6c6d639d63f44b91a139d7c16c599692ab2ddbc220"
    sha256 cellar: :any_skip_relocation, big_sur:       "2bbda4b28a2fc0a99b371617db9343a1e9b43c6e79110033c9a3f6e299913201"
    sha256 cellar: :any_skip_relocation, catalina:      "2bbda4b28a2fc0a99b371617db9343a1e9b43c6e79110033c9a3f6e299913201"
    sha256 cellar: :any_skip_relocation, mojave:        "2bbda4b28a2fc0a99b371617db9343a1e9b43c6e79110033c9a3f6e299913201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d805874ee4affae3fe607f6c6d639d63f44b91a139d7c16c599692ab2ddbc220"
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
