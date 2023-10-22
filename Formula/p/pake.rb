require "language/node"

class Pake < Formula
  desc "Turn any webpage into a desktop app with Rust"
  homepage "https://github.com/tw93/pake#readme"
  url "https://registry.npmjs.org/pake-cli/-/pake-cli-2.3.3.tgz"
  sha256 "f9be10cbfc844bd18dd2205ff42ce27eaea910115478b094dbc46e296709539f"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/pake --version")
    assert_match "2.3.3", output
  end
end
