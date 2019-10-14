require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-14.0.1.tgz"
  sha256 "d1bd4bdf821a0053a5972febd06ca8c9652d2cc0a62844e2b3bb521a73032b4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3414a21797465061324d5fb517546b9b26dec4f66d99cfd56393fc144e37b86f" => :catalina
    sha256 "1b7b95e489a1e63f52412bbd0fb053e0debe8c52ffbb3f8cf039510f32361b3c" => :mojave
    sha256 "bb119118bdee2f95492a21515064644fa9954ab72d4174798b21ef8fbeaf4729" => :high_sierra
    sha256 "a50e8d3910abb9888f08a1a8e91c5555d2ebb8bd5cc5750a8ee903dd83434684" => :sierra
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
