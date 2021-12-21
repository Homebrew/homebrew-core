require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.4.0.tgz"
  sha256 "dc92c5ee2fa439e4b066f249cbe5fae096d78718119f4b44ef10d49533aa072c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d3cbee2516ff1658f6a68b685836f1241e795d5c042fe6a0f1cd9901bf9276c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d3cbee2516ff1658f6a68b685836f1241e795d5c042fe6a0f1cd9901bf9276c"
    sha256 cellar: :any_skip_relocation, monterey:       "165377a78c86b5491a8604c3f9269ce2f970a536656784b0387c8d882e810d08"
    sha256 cellar: :any_skip_relocation, big_sur:        "165377a78c86b5491a8604c3f9269ce2f970a536656784b0387c8d882e810d08"
    sha256 cellar: :any_skip_relocation, catalina:       "165377a78c86b5491a8604c3f9269ce2f970a536656784b0387c8d882e810d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b48e7c72557e1f81629454efab89da9f32d81392f14f37f09bd2de8f4c87e92"
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
