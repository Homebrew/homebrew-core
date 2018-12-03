require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-8.0.0.tgz"
  sha256 "e0080e6e9b6886854b86d5b0001024d6d0b30d9a81cdacf6578d9965ee389db0"

  bottle do
    cellar :any_skip_relocation
    sha256 "83c029f43ea6d7d746b2d8478ccecb378a527b42d718be5469ea40591fba9ca5" => :mojave
    sha256 "93dc19262ec9c53abacdce711a82dbe00888ef08bb697b96f0c4e0f7f144c537" => :high_sierra
    sha256 "e44bf042d6534ff5f2d0f6ff09fbc882c30bdf72b3905494ef78303b5bc521ba" => :sierra
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
