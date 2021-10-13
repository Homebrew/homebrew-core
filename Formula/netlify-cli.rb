require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.12.0.tgz"
  sha256 "5d50210d00e014e15b61c6bf901cd1a1df973100e3f11b8bfb09f846f6ddf169"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afa112c633f8d9bdbc9771168ce3012a36735ffa72fc5a89a0ea2595b8768885"
    sha256 cellar: :any_skip_relocation, big_sur:       "bf0cb980ede72f162d80dccb8d15eba2d239293886bdb4e1430025576412ea50"
    sha256 cellar: :any_skip_relocation, catalina:      "bf0cb980ede72f162d80dccb8d15eba2d239293886bdb4e1430025576412ea50"
    sha256 cellar: :any_skip_relocation, mojave:        "bf0cb980ede72f162d80dccb8d15eba2d239293886bdb4e1430025576412ea50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b26a068d051dd26ba467ee457dc12d490b338c3cae94e380cc32786e8760df7"
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
