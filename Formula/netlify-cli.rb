require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.1.0.tgz"
  sha256 "88ba3a0d406361ea7c65fd9c114e860cdfe3cd0c2c5a4d2a81aabbebc2f89610"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97307959f5019b87b4f8a04803cbeca7a3d4358a9e0f5a1b8e967f9d19257372"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97307959f5019b87b4f8a04803cbeca7a3d4358a9e0f5a1b8e967f9d19257372"
    sha256 cellar: :any_skip_relocation, monterey:       "fec4696105de095b9b89348ebfb19236f1a2a39d960bb43ae5011a606bf321b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "fec4696105de095b9b89348ebfb19236f1a2a39d960bb43ae5011a606bf321b1"
    sha256 cellar: :any_skip_relocation, catalina:       "fec4696105de095b9b89348ebfb19236f1a2a39d960bb43ae5011a606bf321b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde0994d27b6f5fba3e53352d46e35db6ea7d8da77d7db4833d2f51eaacba040"
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
