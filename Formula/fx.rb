require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-9.0.0.tgz"
  sha256 "25a78d1369ddda3f12c6fb1822a148e577d1d3262b79f8f3b5029bd15ee09c74"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8ef5f734864c81d83a0b2dc1f9a738ad574089c6da3013b74d06725f0d0363f" => :mojave
    sha256 "70af1bda1e8410b223d9e574b4ed70e28736018a5b4251489631af588e9c7eeb" => :high_sierra
    sha256 "73f3a1b6b33fec6089facf542b2add9d960d8e96a6bcac9f2b8468503d98f71b" => :sierra
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
