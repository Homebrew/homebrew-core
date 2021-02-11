require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.12.tgz"
  sha256 "5d0ec60d831ea557eab7eede07b0eabe7bae6e8df47fd277039b1886e590cb94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f069e6c89d79f36ead8db0a1b517ed39479ac4491683fd360ab914d01ea9cb86"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2ea709290abec4606199bf178fa4098caa72b13d7f28c84215fef3edc62330b"
    sha256 cellar: :any_skip_relocation, catalina:      "fec740e0c223a900b9e616bf814962bf6582ca8b70d5bf6130a09aa36698e5af"
    sha256 cellar: :any_skip_relocation, mojave:        "2dc8e4047768c7c4d7cf4756733b58ff53f0a3e6065f2eb016ff422ac166b1c2"
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
