require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.46.tgz"
  sha256 "e029ab2338e8da8fc3aab028512df7465194c28265479d77fa0f87dc9a9308f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c37345d3a41f14a962e59f6a6bf70db49b4d63911483c0fe3488ad374583222e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c37345d3a41f14a962e59f6a6bf70db49b4d63911483c0fe3488ad374583222e"
    sha256 cellar: :any_skip_relocation, monterey:       "a05b7e2fdd02840df96a6894f488bd6c34bb742199354fdbe7c69e7ec165cb27"
    sha256 cellar: :any_skip_relocation, big_sur:        "a05b7e2fdd02840df96a6894f488bd6c34bb742199354fdbe7c69e7ec165cb27"
    sha256 cellar: :any_skip_relocation, catalina:       "a05b7e2fdd02840df96a6894f488bd6c34bb742199354fdbe7c69e7ec165cb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c37345d3a41f14a962e59f6a6bf70db49b4d63911483c0fe3488ad374583222e"
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
