require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.37.tgz"
  sha256 "98fff58a0640a5602ff189f8f6d92eb715bc302288155f323efce3457d4d61c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1bf8c7d311a75c3467664edef8e951e4974e5f5443d92d9727b9b4d6b85111"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a1bf8c7d311a75c3467664edef8e951e4974e5f5443d92d9727b9b4d6b85111"
    sha256 cellar: :any_skip_relocation, monterey:       "8bee607c10cfbed2063125b434c38799e5314b6ed41f7be2ed3dfbcff3cc3661"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bee607c10cfbed2063125b434c38799e5314b6ed41f7be2ed3dfbcff3cc3661"
    sha256 cellar: :any_skip_relocation, catalina:       "8bee607c10cfbed2063125b434c38799e5314b6ed41f7be2ed3dfbcff3cc3661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a1bf8c7d311a75c3467664edef8e951e4974e5f5443d92d9727b9b4d6b85111"
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
