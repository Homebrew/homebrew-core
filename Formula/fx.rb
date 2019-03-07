require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-12.0.2.tgz"
  sha256 "b17a98ef6d8db63b7fa29ddb5298ffb35e38929bb08c74fe9c27047a9f322854"

  bottle do
    cellar :any_skip_relocation
    sha256 "9803ce4be6a5c89ed0c0c04aa5728389aecf58624a572da98daf7153d3675c5a" => :mojave
    sha256 "665ca558394b6803651a48d0036dd5e85a36c32612677645da61eb33be682661" => :high_sierra
    sha256 "6cfcc6ef71fb6d81fbcdd0ee318524f02ee60a6e5ec978255afc0b3672bd5904" => :sierra
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
