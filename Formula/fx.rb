require "language/node"

class Fx < Formula
  desc "Command-line JSON processing tool"
  homepage "https://github.com/antonmedv/fx"
  url "https://registry.npmjs.org/fx/-/fx-12.0.0.tgz"
  sha256 "b33fafe37ec52ce9a00f8a414e83f47866705514e0f2819222b07d5346bf7f60"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ec14c7dcfd4a2243e42285ff62e6f2aaf1a798af8bbc3528454e7e39d2d17d4" => :mojave
    sha256 "308b9a104d108613b66901d2437c7d33923ae5e397a89289e109b155a73cdd81" => :high_sierra
    sha256 "f0e50d1e836fe0336806d93d229f507dee0c923b18284c5630c666e15f270ba4" => :sierra
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
