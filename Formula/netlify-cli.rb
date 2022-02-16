require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.6.0.tgz"
  sha256 "46c57603f9f0884f304cf76827e8b656c983e35fcfc308281c996c06b4ea828c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5021db474a5dde924a86f2934ba5b410d6f29902a32e1432580626a4c6b74ca3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5021db474a5dde924a86f2934ba5b410d6f29902a32e1432580626a4c6b74ca3"
    sha256 cellar: :any_skip_relocation, monterey:       "f5930eeec6a6ddc4b3f1d4c611ace0a45c1cba849a2f82a2e83d1ab7088d1a16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5930eeec6a6ddc4b3f1d4c611ace0a45c1cba849a2f82a2e83d1ab7088d1a16"
    sha256 cellar: :any_skip_relocation, catalina:       "f5930eeec6a6ddc4b3f1d4c611ace0a45c1cba849a2f82a2e83d1ab7088d1a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec32fd88b54bfed65b9f4e17fd3e07ef809e9592e4a80d12192fc13e2794c77"
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
