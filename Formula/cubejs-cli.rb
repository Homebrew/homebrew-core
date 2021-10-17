require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.42.tgz"
  sha256 "6967fb13d313099e76e053df415ad306769ac878f4b07e8c918c9e30c265bae1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0fae673600d93c8b7db1a3e12febc8ef1a7a6df347f64759f48c1d156ce8b95c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4142e522f80c2ee181496f9a6db3e4990317ef9b07cd301ddc40e15cc721e6a8"
    sha256 cellar: :any_skip_relocation, catalina:      "4142e522f80c2ee181496f9a6db3e4990317ef9b07cd301ddc40e15cc721e6a8"
    sha256 cellar: :any_skip_relocation, mojave:        "4142e522f80c2ee181496f9a6db3e4990317ef9b07cd301ddc40e15cc721e6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fae673600d93c8b7db1a3e12febc8ef1a7a6df347f64759f48c1d156ce8b95c"
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
