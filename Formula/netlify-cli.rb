require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.3.0.tgz"
  sha256 "6d1f2d02a64ae8d3538c28101dd5d98077eb7d4758d5825e1211f70b95bff292"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5907b3af0e0395672016a40b48b288023081f6fb15ca9e28a5bb8e82aa73bf5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5907b3af0e0395672016a40b48b288023081f6fb15ca9e28a5bb8e82aa73bf5b"
    sha256 cellar: :any_skip_relocation, monterey:       "f70fc9bc9be2631922807d80178322853dba806314b586bf82eebb3ebe06b6cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "f70fc9bc9be2631922807d80178322853dba806314b586bf82eebb3ebe06b6cc"
    sha256 cellar: :any_skip_relocation, catalina:       "f70fc9bc9be2631922807d80178322853dba806314b586bf82eebb3ebe06b6cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8d6bebbfe5c4320b52f8bf90992f6bd7e7e55309042fbfdf1981093bc4a2a1"
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
