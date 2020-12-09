require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.5.tgz"
  sha256 "5b1b3b83406e2e62cccafdf9c38897f05b2c7059e04edbb248e4d70786b88f2e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6ede8e7623c2c72d6ceef80ba483a0393582136dea882b50c93c251db2bbbcd4" => :big_sur
    sha256 "fe1249f150f92e4988a7373fb676f2d1d03cd7903cdfa3673efaa8518429a8e2" => :catalina
    sha256 "b6643a91558a71782eacc14380c813be23b2ad357d9829066b5788262cada392" => :mojave
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
