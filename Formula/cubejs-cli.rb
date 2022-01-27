require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.23.tgz"
  sha256 "e69f6189564c5cdf96e5b21d9c7403bed14f7495f5eb0619762ede7c2a646941"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0603b447512017cae64d069bd51c6e0ea263b585b731fb93611af5f38621e04c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0603b447512017cae64d069bd51c6e0ea263b585b731fb93611af5f38621e04c"
    sha256 cellar: :any_skip_relocation, monterey:       "6481075efad797011c0bde9a3e43a74325d872618aa9b42e402db6c4a32c20bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6481075efad797011c0bde9a3e43a74325d872618aa9b42e402db6c4a32c20bf"
    sha256 cellar: :any_skip_relocation, catalina:       "6481075efad797011c0bde9a3e43a74325d872618aa9b42e402db6c4a32c20bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0603b447512017cae64d069bd51c6e0ea263b585b731fb93611af5f38621e04c"
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
