require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.28.tgz"
  sha256 "6b05a19a711730d3c689fbd5d7b45d6c88dae1e4133c3cc73b87079a428551a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dda864c875dc8d970356b972774f6f3de342c4a2e27aae3ec44de86200ec48f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dda864c875dc8d970356b972774f6f3de342c4a2e27aae3ec44de86200ec48f"
    sha256 cellar: :any_skip_relocation, monterey:       "f2c330cfaccaee464783d629bf5d30a51c3273fd3d11da8c0200f1c3738a5654"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2c330cfaccaee464783d629bf5d30a51c3273fd3d11da8c0200f1c3738a5654"
    sha256 cellar: :any_skip_relocation, catalina:       "f2c330cfaccaee464783d629bf5d30a51c3273fd3d11da8c0200f1c3738a5654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dda864c875dc8d970356b972774f6f3de342c4a2e27aae3ec44de86200ec48f"
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
