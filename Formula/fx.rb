require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-12.0.2.tgz"
  sha256 "b17a98ef6d8db63b7fa29ddb5298ffb35e38929bb08c74fe9c27047a9f322854"

  bottle do
    cellar :any_skip_relocation
    sha256 "4163364b0bcaf765f82bb3fff8cab256af4baaab0ef8fc14c7396dacc362e43b" => :mojave
    sha256 "ae1d66ad8f33c2fde8af1bbe915401aa86a80977ef8c11cdf41e95e4ced5cdc1" => :high_sierra
    sha256 "3b29c04c8fb84e3f6077c18bee47ab82d525554527d3d8ca3329de176fda6b39" => :sierra
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
