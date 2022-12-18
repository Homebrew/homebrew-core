require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.29.tgz"
  sha256 "23033db39967f9cac2e16090007de064430ae87c629bc0d5b5f6fb4e57c3cf3f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9af1f63f01161a55173cc7889fc539e4f6a881d69e28c2f0d6daa2ad55e6c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9af1f63f01161a55173cc7889fc539e4f6a881d69e28c2f0d6daa2ad55e6c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa9af1f63f01161a55173cc7889fc539e4f6a881d69e28c2f0d6daa2ad55e6c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d3c348df52bea042883c3fd18854cfbab0eb96aab7f400668a7d4f12b2d668d3"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c348df52bea042883c3fd18854cfbab0eb96aab7f400668a7d4f12b2d668d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3c348df52bea042883c3fd18854cfbab0eb96aab7f400668a7d4f12b2d668d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9af1f63f01161a55173cc7889fc539e4f6a881d69e28c2f0d6daa2ad55e6c7"
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
