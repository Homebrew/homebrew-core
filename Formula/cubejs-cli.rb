require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.65.tgz"
  sha256 "448b2c8b5e3ef9f9f7368727b5e3bdc87ff9ac978f062a13a7ddf62e7a3bb9eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc0a20f76ad75fec9d7e31452dabb00aa89939180b5e344aff00b6b7900090b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc0a20f76ad75fec9d7e31452dabb00aa89939180b5e344aff00b6b7900090b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc0a20f76ad75fec9d7e31452dabb00aa89939180b5e344aff00b6b7900090b6"
    sha256 cellar: :any_skip_relocation, ventura:        "20910e020be4b48109b0161666bc9aeb29f5a861a61c1a5ab6c9ef70fabcb70f"
    sha256 cellar: :any_skip_relocation, monterey:       "20910e020be4b48109b0161666bc9aeb29f5a861a61c1a5ab6c9ef70fabcb70f"
    sha256 cellar: :any_skip_relocation, big_sur:        "20910e020be4b48109b0161666bc9aeb29f5a861a61c1a5ab6c9ef70fabcb70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc0a20f76ad75fec9d7e31452dabb00aa89939180b5e344aff00b6b7900090b6"
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
