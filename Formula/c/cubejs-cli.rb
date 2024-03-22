require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.1.tgz"
  sha256 "a67e24f48dd8fae2fcf80bef8c19025cc6041946ada874302787acd088c080df"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6bef6e759074e172bc97a9152786ce68ca56b5276bf928be3b8b95b463b0373"
    sha256 cellar: :any,                 arm64_ventura:  "e6bef6e759074e172bc97a9152786ce68ca56b5276bf928be3b8b95b463b0373"
    sha256 cellar: :any,                 arm64_monterey: "f6f13475baf8baf4e8d70b7d6d9d19dbb631b8a45a72fe5fa234d2ff99ef070e"
    sha256 cellar: :any,                 sonoma:         "6c772fd9b5d49158767061d3d08c26b75d4d98724e6c4ade1abfc9ac23391151"
    sha256 cellar: :any,                 ventura:        "6c772fd9b5d49158767061d3d08c26b75d4d98724e6c4ade1abfc9ac23391151"
    sha256 cellar: :any,                 monterey:       "6c772fd9b5d49158767061d3d08c26b75d4d98724e6c4ade1abfc9ac23391151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def2a42df4ee1c78396c4d6ad42feb8239ab07e8daa6ea1af3390f84931c09b0"
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
