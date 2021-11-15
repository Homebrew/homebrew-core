require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.14.15.tgz"
  sha256 "50cf0d9fad7e7ac5dbe5efe2c062f428c2fb2c2815d3ce4fd4c96095e0291198"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56df9700bea96a408be24805a48c8236463fc06bd989fabc5c786b93c13fe60a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fa14c2706c84daabdacd135f76b653936304d9ea94fcfd956f05b91b4e9516f"
    sha256 cellar: :any_skip_relocation, monterey:       "bcef6546d96001bf53a9b338b8d91673aa92b56462883627f9b0d4424d365bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5b67c89e6c97e586f0007f08aaca3bf14a433abe371f8e62b7f224e54a8afef"
    sha256 cellar: :any_skip_relocation, catalina:       "f5b67c89e6c97e586f0007f08aaca3bf14a433abe371f8e62b7f224e54a8afef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbcdef4c13a3388b8fbb247bf6b10acbed00a79d6726509fa7c56c02b3c8334e"
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
