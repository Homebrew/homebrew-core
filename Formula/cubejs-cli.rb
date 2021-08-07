require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.15.tgz"
  sha256 "278e8121dd79a3de13748d6b57224b90674c4e633cb38abde590d8d6a0549750"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50840bc6cf86a548c98375527e3798e0a28711f8627efadf0a13710823a57707"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce7ea9f026bc35a29c1d45a33639c59c51fe03184d56768c8a3617b486c2776a"
    sha256 cellar: :any_skip_relocation, catalina:      "ce7ea9f026bc35a29c1d45a33639c59c51fe03184d56768c8a3617b486c2776a"
    sha256 cellar: :any_skip_relocation, mojave:        "ce7ea9f026bc35a29c1d45a33639c59c51fe03184d56768c8a3617b486c2776a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50840bc6cf86a548c98375527e3798e0a28711f8627efadf0a13710823a57707"
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
