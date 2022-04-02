require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.16.0.tgz"
  sha256 "48efe2134b83c1bf0970d295026cc0b25066ed3c9cac2b4dbb449b7ecf73ecb4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be8baf65b4a6d29ca6c849c00c8ecf9fdc49b40d96ca4bec794e6a83fdd623b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be8baf65b4a6d29ca6c849c00c8ecf9fdc49b40d96ca4bec794e6a83fdd623b4"
    sha256 cellar: :any_skip_relocation, monterey:       "d59502b4d85ef23517c8502b2da2a8d07897f1f74cf40a9be15f5da4668b48d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d59502b4d85ef23517c8502b2da2a8d07897f1f74cf40a9be15f5da4668b48d4"
    sha256 cellar: :any_skip_relocation, catalina:       "dcb5a82b7349e24a68e50e92722e4f00b84911936fdd0b1c87c83439283d608f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd02a29431e517b892e3aab527266d2fe48003c40bec631ef1ef723b4e96e8ad"
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
