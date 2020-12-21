require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.0.tgz"
  sha256 "f6f763efbb013cf9fabdedec9cccb3d61a8d7fa9cfc1c714ad880cfe76e4f21e"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "74aae6a09c6014f2f765d45120b2b53bcf38ec8507733d7c82f1d61ccc57dd5d" => :big_sur
    sha256 "5b1a26daa707adb9aedacbd0955597c6d8ed5ae3c713915017b9d269bd0f9873" => :catalina
    sha256 "2c224af03ce1cc77b3de25fff97a5120ace81cc9af82166558cd3221cb98a34f" => :mojave
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
