class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.1.tgz"
  sha256 "1e351091e1bddae2481ea9139e426e3386e900c2ad8010a9e9840325c2888635"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "ddaadfdddc67ae54f3a2af87b0b213dc2948456ddb6dc450567aa2ffa1bce603"
    sha256                               arm64_sonoma:  "fdb04c1cb5f7f7b00f60d338da7ae61945634256e72deb255add4284c7dccf06"
    sha256                               arm64_ventura: "47ef66869f1b6ca5fbb218c9b278391dab4d414a0860faa0a952c0390c581a5b"
    sha256                               sonoma:        "d56ca68a87ecd26e55308352958691763d48d8e0c7bd5237995b1b1032202b22"
    sha256                               ventura:       "55689391b9d636b79c83158f63bff0a2cb0e02f41bc5455cfa2d8061e06ee536"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a0dca3cea6b10b9fad3b4211c599dd3f59c42683e5d7396b0a93af2db88029f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca00974438664edb23065058e2e89656cf5ab92b9ccb5093f5ef50e68550c81"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
