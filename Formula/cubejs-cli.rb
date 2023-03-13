require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.5.tgz"
  sha256 "fc4f4b1f303c4d2f024c8aafb11d5836744083880b425681b8d3fcba4cd9043e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b5d534ebab31e14ddc058b831f58fc02df45675a125e460a31a3865d8a32bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04b5d534ebab31e14ddc058b831f58fc02df45675a125e460a31a3865d8a32bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04b5d534ebab31e14ddc058b831f58fc02df45675a125e460a31a3865d8a32bf"
    sha256 cellar: :any_skip_relocation, ventura:        "68864079b88c0306fe79ec7b85af7bbcd684a994b169c88ba8085687de4db745"
    sha256 cellar: :any_skip_relocation, monterey:       "68864079b88c0306fe79ec7b85af7bbcd684a994b169c88ba8085687de4db745"
    sha256 cellar: :any_skip_relocation, big_sur:        "68864079b88c0306fe79ec7b85af7bbcd684a994b169c88ba8085687de4db745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b5d534ebab31e14ddc058b831f58fc02df45675a125e460a31a3865d8a32bf"
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
