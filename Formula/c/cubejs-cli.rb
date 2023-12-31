require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.40.tgz"
  sha256 "85af2593bba4752e7558ac250b4284b056c6d603894ef11b0237cba5669d946e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "637a56e2d612edf64bb04bf2e9385088790713f94fed26d359990481de2347d4"
    sha256 cellar: :any, arm64_ventura:  "637a56e2d612edf64bb04bf2e9385088790713f94fed26d359990481de2347d4"
    sha256 cellar: :any, arm64_monterey: "637a56e2d612edf64bb04bf2e9385088790713f94fed26d359990481de2347d4"
    sha256 cellar: :any, sonoma:         "ca5c77c8ffa7c52cbd7de6da8ae44010847c0087a47a5f0ab82f7c789a3fc41d"
    sha256 cellar: :any, ventura:        "ca5c77c8ffa7c52cbd7de6da8ae44010847c0087a47a5f0ab82f7c789a3fc41d"
    sha256 cellar: :any, monterey:       "ca5c77c8ffa7c52cbd7de6da8ae44010847c0087a47a5f0ab82f7c789a3fc41d"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
