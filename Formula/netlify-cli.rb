require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.14.15.tgz"
  sha256 "50cf0d9fad7e7ac5dbe5efe2c062f428c2fb2c2815d3ce4fd4c96095e0291198"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71bae068162684ab9d96d72c1ee192a5bf2f2131ca754ab89cc6966fa23cc823"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71bae068162684ab9d96d72c1ee192a5bf2f2131ca754ab89cc6966fa23cc823"
    sha256 cellar: :any_skip_relocation, monterey:       "581c7b4a9e0833259d738ac72d9fd4a3ead73059e2ffd6914f399c6f364e5f43"
    sha256 cellar: :any_skip_relocation, big_sur:        "581c7b4a9e0833259d738ac72d9fd4a3ead73059e2ffd6914f399c6f364e5f43"
    sha256 cellar: :any_skip_relocation, catalina:       "581c7b4a9e0833259d738ac72d9fd4a3ead73059e2ffd6914f399c6f364e5f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f1a1deb310f29e11b91645ab84995368e01d963f3b37061395af309ab09eb3"
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
