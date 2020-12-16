require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.24.6.tgz"
  sha256 "c56cf2da114592f8de656c6a02168ef88d3fced95027bb7dbf164a4dd092f771"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2ba25731757ad94c6292af6811c936b56d849b3954a97a4e9ed646ef9b2d028a" => :big_sur
    sha256 "ff9d035ac7548b72372e92ca6c0ffad3ecf6d34ba0da9848011179c29cd9f8e3" => :catalina
    sha256 "66225803a921c539613ad874a02022bc8cddac952aecf49ebde3882c1929505f" => :mojave
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
