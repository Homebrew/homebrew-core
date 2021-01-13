require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.25.16.tgz"
  sha256 "0d2984e1db16d6b3ce865761c7b61e38a96cc55f9e8f93fe82091334a20ddea2"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8631d990d1a690b0b7b965ebc275aa4faa672ed349802efe2089fa4b2e58f166" => :big_sur
    sha256 "a6b0fe7ab492fd4502504361918edc8a48a7f4baa642dba5e64c01c3dd6869d9" => :arm64_big_sur
    sha256 "d55da340f961613ffacfe67756e6bd3ac501d78afe9ab7f19422e255f83f80f4" => :catalina
    sha256 "a6e7658735e6b190a8da6d74ac3bb2b5e90caaac9d70044c98dbbda4ef9ec0c0" => :mojave
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
