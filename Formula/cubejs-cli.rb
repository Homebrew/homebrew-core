require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.20.tgz"
  sha256 "f180bdb64bb2b0c589de0ac9712e31f070b7c7f20c8990bb8a1a68ad9ff87e15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "adc46f74765a187f5ee4b8b3baca690d8eadc8cc0c5b369c2e3e6d7471374fa1"
    sha256 cellar: :any_skip_relocation, big_sur:       "ccceef78db9404bac78398dc9654ee6b3c2892d8f35a8c9d1c21f72b35d0542e"
    sha256 cellar: :any_skip_relocation, catalina:      "ccceef78db9404bac78398dc9654ee6b3c2892d8f35a8c9d1c21f72b35d0542e"
    sha256 cellar: :any_skip_relocation, mojave:        "ccceef78db9404bac78398dc9654ee6b3c2892d8f35a8c9d1c21f72b35d0542e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc46f74765a187f5ee4b8b3baca690d8eadc8cc0c5b369c2e3e6d7471374fa1"
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
