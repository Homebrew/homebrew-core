require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.19.tgz"
  sha256 "6844fb0a356822d139c0f64bceb6837fcd017068434b6f8e1a25d356baac5d83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e297ac1e859a66e41fa0f6248107915ec725b52dff4ba16e2d6334106b40a3c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e297ac1e859a66e41fa0f6248107915ec725b52dff4ba16e2d6334106b40a3c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e297ac1e859a66e41fa0f6248107915ec725b52dff4ba16e2d6334106b40a3c6"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a041683217ca8f7bfc8c61756417cc052ca2765a426d612635c61be79eec50"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a041683217ca8f7bfc8c61756417cc052ca2765a426d612635c61be79eec50"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8a041683217ca8f7bfc8c61756417cc052ca2765a426d612635c61be79eec50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e297ac1e859a66e41fa0f6248107915ec725b52dff4ba16e2d6334106b40a3c6"
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
