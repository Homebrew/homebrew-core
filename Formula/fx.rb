require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-20.0.2.tgz"
  sha256 "7ec01246c8291cd6194587e4fe0eba92a554336ec2342a74c9eb47cf1b41179c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e80865398cc8cd9c22b14a6f5dc9262130597e44f378989a9c8529f51d2608ab" => :catalina
    sha256 "f32846d5b0d2db87652d21e0e0889b2b8747ac9b8abaf6f806c90511431b6cfd" => :mojave
    sha256 "9ad55ab44cc722f61aaabb348ba7d1c5112d60df420e24f059fde002ad0fc9aa" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "bar", shell_output("echo '{\"foo\": \"bar\"}' #{bin}/fx .foo")
  end
end
