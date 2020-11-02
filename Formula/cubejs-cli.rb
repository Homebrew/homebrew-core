require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.23.6.tgz"
  sha256 "c001c7314fd86fb087da32c412bcf055b2ac30c7d6148ff5b7d28ca3a287f6c3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fe27b3b649d4dd7d2b91ffbcb67e6d7cf59f212c0c222f485d7b47343fbf5c09" => :catalina
    sha256 "14b9611316f812f953e2ff3366d503a235a006f5f676e5d3a218f077fb13b1f0" => :mojave
    sha256 "d48c2295e137c55a2e4375173260ba1491519fbec401e1302e5d7ce7f009d441" => :high_sierra
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
