require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-10.0.0.tgz"
  sha256 "21779d44e06842e3f8e238a4e698f92d12db8a0999408160f4284d5d07ac03fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "fff03a23bd3d5e976cd4bcc4db8689450095c7c6f1d494d635c055777c72d9a3" => :mojave
    sha256 "e5d683615082ca15a79c87b29d97f710b8b0a6ef0e278e520a76309e85edf87a" => :high_sierra
    sha256 "d5b83ba12c95ff009dd7804a6db3e99677d005c7e85453b18b4b2f942bb09ed7" => :sierra
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
