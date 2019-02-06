require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-11.0.1.tgz"
  sha256 "897ecdf706fe235ac8da7145b4790a34791be477f9b0153d9b2fd27a5dc768d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "261c42aa0ad935931d788523fb068ac7558d719b9f2132958038ca362fdb7b65" => :mojave
    sha256 "a73137b4350e4452333872f373e73ff4b8cb852aa640d4a89b9c8d5e62aa42f7" => :high_sierra
    sha256 "6452dd1164c755beb442fbbed994712798e35eca4a6b70235cb93980a0ff4265" => :sierra
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
