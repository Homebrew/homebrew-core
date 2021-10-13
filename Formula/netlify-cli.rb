require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.12.5.tgz"
  sha256 "94fd07f43c7b28a7a76dc2c5619d3cd25aa69c28ffad7c710806e78c5a738830"
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
