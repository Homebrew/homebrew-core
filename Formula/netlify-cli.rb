require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.7.0.tgz"
  sha256 "b5c848027e35a5fead4f9ff8638bb4b831e9418d51d0613081b9266735eb1001"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e27a048d8717d7d1a8f1d5dbd9fc5c10f54645a54b76e3bcc8a37bf667fb4d9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e27a048d8717d7d1a8f1d5dbd9fc5c10f54645a54b76e3bcc8a37bf667fb4d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa76122119bbfbe2e89bdb66c33413f9e1b3f67f866b7d098c6d46d88fc29f54"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa76122119bbfbe2e89bdb66c33413f9e1b3f67f866b7d098c6d46d88fc29f54"
    sha256 cellar: :any_skip_relocation, catalina:       "aa76122119bbfbe2e89bdb66c33413f9e1b3f67f866b7d098c6d46d88fc29f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d2d70a1c8c41708c8d0b5d1138724aa81be1f3750dd431c748a777f4b1f248b"
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
