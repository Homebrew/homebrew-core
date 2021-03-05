require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.10.6.tgz"
  sha256 "3e4ea80d6e0289a8accee2d886c456a793867fa05fc589541dfebaab189cfc8f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3403aaafe4872fc65af6c7b35f2e900cb03967e9bb67921947f7cd5cf214ceed"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a8bec809593773b36b4527db5e8a389f209dfb9c9a935c8a136f89043beca6d"
    sha256 cellar: :any_skip_relocation, catalina:      "0cbbc8a1b91e2c49cfecd7db2803db23e8c125349a2e9c806fb8f24626dc014c"
    sha256 cellar: :any_skip_relocation, mojave:        "deb1d67bdeb580590fb387ead8ade02822b73e5036ca2e65297eea7ed00523e8"
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
