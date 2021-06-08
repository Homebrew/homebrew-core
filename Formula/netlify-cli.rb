require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.35.8.tgz"
  sha256 "9507b1e495a9eb74d94483cd08db30866697bdc6594074a97192eb1987c7383d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d845eabb35c5bcec4fbc61a67054abd8a4d8805a0ec48401d9888e6b828cd109"
    sha256 cellar: :any_skip_relocation, big_sur:       "1bf072bd1d351300c5093cebcef0d9d534a3db925029c8d3eab2088ed02e8089"
    sha256 cellar: :any_skip_relocation, catalina:      "1bf072bd1d351300c5093cebcef0d9d534a3db925029c8d3eab2088ed02e8089"
    sha256 cellar: :any_skip_relocation, mojave:        "1bf072bd1d351300c5093cebcef0d9d534a3db925029c8d3eab2088ed02e8089"
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
