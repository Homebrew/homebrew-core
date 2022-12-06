require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.21.tgz"
  sha256 "fd3d40d4f13bfddfe6fc1bdad885e419157a8a24e16c5dda995152b721fbb981"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185516e5c58356127012112baf880e67dad6e11fa28463dd029bbee2d9f9a19e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "185516e5c58356127012112baf880e67dad6e11fa28463dd029bbee2d9f9a19e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "185516e5c58356127012112baf880e67dad6e11fa28463dd029bbee2d9f9a19e"
    sha256 cellar: :any_skip_relocation, ventura:        "e14316bed5b57f21251125816fd6f42d6e2e39a5aaa7b1c48797a0efe24cadf8"
    sha256 cellar: :any_skip_relocation, monterey:       "e14316bed5b57f21251125816fd6f42d6e2e39a5aaa7b1c48797a0efe24cadf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e14316bed5b57f21251125816fd6f42d6e2e39a5aaa7b1c48797a0efe24cadf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "185516e5c58356127012112baf880e67dad6e11fa28463dd029bbee2d9f9a19e"
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
