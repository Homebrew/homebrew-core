require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.2.1.tgz"
  sha256 "ab0bca255977f7f9acdce0e53222f0dc1b18eeb4942aaf3e5928e9a610de568c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15750a5392d830d4075c8d3eba1ac30d41005a0dcc460b7d74c147e60fac311c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15750a5392d830d4075c8d3eba1ac30d41005a0dcc460b7d74c147e60fac311c"
    sha256 cellar: :any_skip_relocation, monterey:       "191256cf92037e8111c5427e67e7eace659d4b110f3acaaba1f51519b58a1847"
    sha256 cellar: :any_skip_relocation, big_sur:        "191256cf92037e8111c5427e67e7eace659d4b110f3acaaba1f51519b58a1847"
    sha256 cellar: :any_skip_relocation, catalina:       "191256cf92037e8111c5427e67e7eace659d4b110f3acaaba1f51519b58a1847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15750a5392d830d4075c8d3eba1ac30d41005a0dcc460b7d74c147e60fac311c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
