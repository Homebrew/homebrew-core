require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-12.0.0.tgz"
  sha256 "b33fafe37ec52ce9a00f8a414e83f47866705514e0f2819222b07d5346bf7f60"

  bottle do
    cellar :any_skip_relocation
    sha256 "499970065a21912329027f0e93d8b5ca71709ce145e2d9adedd3ad395379bd89" => :mojave
    sha256 "fd45a3cdc3f7fb3d22a2e775c54a0bb1c1fb530cf514e1761150c1ca0e0b60ad" => :high_sierra
    sha256 "16ee652106674168a795a0fa46da3dde3789c3fd20a144279f13ac02b3e59b3e" => :sierra
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
