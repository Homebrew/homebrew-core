require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.15.tgz"
  sha256 "676ee24c3fb1821f9cdc72861eef3092573b858d1a1c8f8476452ce46028a3c8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3260cbefcbb431b15363972ae241ef11742434a85340b28cc4e0660db9c8b58a"
    sha256 cellar: :any_skip_relocation, big_sur:       "1be9d50a9f8cff287c5038ede2fc1d6dca80ecaf686e4a9194a62e11cb232fb5"
    sha256 cellar: :any_skip_relocation, catalina:      "1be9d50a9f8cff287c5038ede2fc1d6dca80ecaf686e4a9194a62e11cb232fb5"
    sha256 cellar: :any_skip_relocation, mojave:        "1be9d50a9f8cff287c5038ede2fc1d6dca80ecaf686e4a9194a62e11cb232fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5dc2882efc8a57e3f0d5300a6d1e287391abc4389ad77c884c05e3a4736731d"
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
