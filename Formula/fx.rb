require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-20.0.0.tgz"
  sha256 "dd5d765cac1828dd1c7466d51d8eccf19255dc6c978530b2b8c85d5bba6b0549"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "578129a00faa6be9ba743f231a2ca413b5e0071da074e7e240caa95ec950c215" => :catalina
    sha256 "374f6c150bf3693a44d4a350e6c7c906f9cbc599b20e8865a11d516ad777fe50" => :mojave
    sha256 "957ee908264b5ad9c9efbd5d3f298c6eb58c4a563f7f78faa12d2ab3cd72e74a" => :high_sierra
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
