require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.15.tgz"
  sha256 "41d59916413fb9ebf046ee6e50d63448e100ecc46b1cdd9add79b845b59e3adb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "123dea07309e6f129200e6323f0bce0bbe92abb63044b84e8c5c53a04ea8b9ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123dea07309e6f129200e6323f0bce0bbe92abb63044b84e8c5c53a04ea8b9ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "123dea07309e6f129200e6323f0bce0bbe92abb63044b84e8c5c53a04ea8b9ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f2df01199983c87e5fedfe085ff79f2c04ce8ba12afdea8b82723c566adf403f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2df01199983c87e5fedfe085ff79f2c04ce8ba12afdea8b82723c566adf403f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2df01199983c87e5fedfe085ff79f2c04ce8ba12afdea8b82723c566adf403f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123dea07309e6f129200e6323f0bce0bbe92abb63044b84e8c5c53a04ea8b9ba"
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
