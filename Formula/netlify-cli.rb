require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.35.1.tgz"
  sha256 "baff0002e28b40a6a3aaae691cb6a9147f044620cef426bf39d52e16eccfb4f7"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ccf806768334e58c9f4a9c6a2e060337077bd53d2696aa83bd170e9c4de0d7b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "12cc084a911fa4371e3bd45e14cda81488e8b1780631e0cf26ae3fdab3ec81c9"
    sha256 cellar: :any_skip_relocation, catalina:      "12cc084a911fa4371e3bd45e14cda81488e8b1780631e0cf26ae3fdab3ec81c9"
    sha256 cellar: :any_skip_relocation, mojave:        "12cc084a911fa4371e3bd45e14cda81488e8b1780631e0cf26ae3fdab3ec81c9"
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
