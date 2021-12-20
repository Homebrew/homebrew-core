require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.2.0.tgz"
  sha256 "af6499e4b6e62fa4a97c6477b2fb41da3c569ca1b3e196af9f40c60adf0aea6d"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b77d0f8e2d91b49af273373c952b9fd83469b2b6b948e5f7e7e248356f882a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b77d0f8e2d91b49af273373c952b9fd83469b2b6b948e5f7e7e248356f882a2"
    sha256 cellar: :any_skip_relocation, monterey:       "7a0c4cf17dc49ffe5f06a8493492c3b8a71cd4921d3fa25c62d5ca2238785ed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a0c4cf17dc49ffe5f06a8493492c3b8a71cd4921d3fa25c62d5ca2238785ed2"
    sha256 cellar: :any_skip_relocation, catalina:       "7a0c4cf17dc49ffe5f06a8493492c3b8a71cd4921d3fa25c62d5ca2238785ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45bbaa81540df666fb95e9d19454fce2e314e14341c5eab4ffcf929185bc5268"
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
