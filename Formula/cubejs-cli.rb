require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.17.tgz"
  sha256 "c7eb5f78f0dcd21d2afa6f7e91031fc12cb55bca7195936436bbfed04248c958"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19722058ef662c0dbb1a4a8a35e29729d01cb0c8c55b4d2b59d6d3d9a1cc0080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19722058ef662c0dbb1a4a8a35e29729d01cb0c8c55b4d2b59d6d3d9a1cc0080"
    sha256 cellar: :any_skip_relocation, monterey:       "094e5173057197dd18c4a5fba2966ec357b92dbc78cd6f3f6c6d78ddd741071b"
    sha256 cellar: :any_skip_relocation, big_sur:        "094e5173057197dd18c4a5fba2966ec357b92dbc78cd6f3f6c6d78ddd741071b"
    sha256 cellar: :any_skip_relocation, catalina:       "094e5173057197dd18c4a5fba2966ec357b92dbc78cd6f3f6c6d78ddd741071b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19722058ef662c0dbb1a4a8a35e29729d01cb0c8c55b4d2b59d6d3d9a1cc0080"
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
