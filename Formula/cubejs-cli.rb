require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.49.tgz"
  sha256 "e5dcab8858bd66216ec928bd8ea3fa6d1bacc1587fb1891b7a0cee0bc22a537d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9b739f3f29099d01cbf37589bd68061e382ded726a08f31b2f41e5bbad84d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb9b739f3f29099d01cbf37589bd68061e382ded726a08f31b2f41e5bbad84d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb9b739f3f29099d01cbf37589bd68061e382ded726a08f31b2f41e5bbad84d2"
    sha256 cellar: :any_skip_relocation, ventura:        "d9dc5bd94186933cca96e8575f9be79cabe3ab1d6df49c4b8e8b0ef7c6183e87"
    sha256 cellar: :any_skip_relocation, monterey:       "d9dc5bd94186933cca96e8575f9be79cabe3ab1d6df49c4b8e8b0ef7c6183e87"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9dc5bd94186933cca96e8575f9be79cabe3ab1d6df49c4b8e8b0ef7c6183e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9b739f3f29099d01cbf37589bd68061e382ded726a08f31b2f41e5bbad84d2"
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
