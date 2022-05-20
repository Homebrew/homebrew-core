require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.3.tgz"
  sha256 "618c90a8576d32f47bbcde95f266d80759a8a16e9e03f615c792bd3ffe83a8ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62cf4bb68cca61d3b6d1a8750847afdd4d14a0a69367b6e9fbadb55a5da761ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62cf4bb68cca61d3b6d1a8750847afdd4d14a0a69367b6e9fbadb55a5da761ac"
    sha256 cellar: :any_skip_relocation, monterey:       "e68896a6e05b242cbea2269f080c5dc4613d4001dfdcde1abb34c293001c03d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e68896a6e05b242cbea2269f080c5dc4613d4001dfdcde1abb34c293001c03d2"
    sha256 cellar: :any_skip_relocation, catalina:       "e68896a6e05b242cbea2269f080c5dc4613d4001dfdcde1abb34c293001c03d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62cf4bb68cca61d3b6d1a8750847afdd4d14a0a69367b6e9fbadb55a5da761ac"
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
