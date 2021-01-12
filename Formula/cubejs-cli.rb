require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.15.tgz"
  sha256 "55ad5b80aaa1d000382e53c8c9c45fe3595d615a060d6c0c19e6cbb413822542"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b65a580f18cc2c3604b7f02f16bdbc363b1644737e31df1ff7c9a19a862ccf0d" => :big_sur
    sha256 "f0a7a8660907dc496ee3414455761877c87981cce04d2d6f72b2ba5889f29f84" => :arm64_big_sur
    sha256 "3678dd6d13c9747e0e8e0221d43ec5e4f6b32cdc3f9444ad1ca556d8cf6877d1" => :catalina
    sha256 "8fa6dbff0c999fe7d6746133e21404c5071065c79abb60c3bbdcf4754c323715" => :mojave
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
