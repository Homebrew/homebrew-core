require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-14.1.0.tgz"
  sha256 "d9db02c69240b41f00a80a6fcc824fe6e2c1ee14fb8c4b50d521b1666bb8901c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ceee78aab36c25dc0aaafb55eed34e632bba6a7d91c0b8ae0b624a94f96475f" => :catalina
    sha256 "e430433053034f7a86d5808f2af93aa4b9f53bca4c334b76991e21cecb555ab5" => :mojave
    sha256 "a2ea9c508a5b9e98a43cdedf5b6eaa00f2091de3d716368d95239a0a3d77c398" => :high_sierra
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
