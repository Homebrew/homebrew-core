require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.21.1.tgz"
  sha256 "d331e475422224ebbe164a71f42075830929f5682ba4e52f34acbe6159a1fc86"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "66c05a8518d45e54babd18c3b972af61b4ffe487eb4186b9310aa4efd5eada0d" => :catalina
    sha256 "08fb6420a682983379de714fbb9d276d8dd660a80e9c8ddcb681d159588a8451" => :mojave
    sha256 "3a8313fa8d5d0d81d67f7350b182a99c0e9deed6c23f7eb2914a7b0dc94bc73b" => :high_sierra
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
