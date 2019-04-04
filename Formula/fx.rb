require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-14.0.1.tgz"
  sha256 "d1bd4bdf821a0053a5972febd06ca8c9652d2cc0a62844e2b3bb521a73032b4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed34e5ddeb8e06d1e8fd140a36a7570c47298ae6c02d76a5e43b60976d42db3b" => :mojave
    sha256 "09508bf23ec0e0dc7ba35e8b620f4363cc36c4db36ec6c0cb399b29c707e1e28" => :high_sierra
    sha256 "6b40566a2032321e522d17200c7e1891d1f8882905c6664edd5e460362be7978" => :sierra
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
