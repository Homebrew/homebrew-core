require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.30.3.tgz"
  sha256 "68058f917c66a1a4f3a3fec25c21d9a956d1bdb8b935652663afe296d95762b5"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f2d2417dd7e385d9f5c516800d6618127998ed40701a5957bd511a7c387b3c1"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e9b828270dd8d184b52f2d3de32925819c3e6eeea66e96aec96b5e2a40fd2ff"
    sha256 cellar: :any_skip_relocation, catalina:      "2e9b828270dd8d184b52f2d3de32925819c3e6eeea66e96aec96b5e2a40fd2ff"
    sha256 cellar: :any_skip_relocation, mojave:        "2e9b828270dd8d184b52f2d3de32925819c3e6eeea66e96aec96b5e2a40fd2ff"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
