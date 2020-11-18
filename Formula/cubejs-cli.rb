require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.12.tgz"
  sha256 "caad7b3e0aa33d0dfe3cc5487fd0737e8240c7d9c13c5dc024375a770f5d07c2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8183252cfaec40fe59d84ab0c1717797ea761689dcd889e357bfc18005ad92d0" => :big_sur
    sha256 "7b51abf0efb914459d11ff9ee4fa214d60fb7fbff4c6f24dd382e45d5e2a246c" => :catalina
    sha256 "ed9aa5ba6679914cb9d0e1ce391c282bfb48c76c033dc2f83bf17c0a4e68c352" => :mojave
    sha256 "9700dfe0157fbb88a61362033c036d0ef8f4b892015a2513b62783e341347129" => :high_sierra
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
