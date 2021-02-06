require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.5.tgz"
  sha256 "2d68e05c20e311aa61202ab06d85af482b3c325c6bc763581f116584ecf575e4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c91d1e2be39205db743d7d742004719b109b4ad718eff7696f6314ed6b4f148f"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b526e8d4c36837f79428d01872b5d1ac8a495e8871ba4953f43a566cc12ecca"
    sha256 cellar: :any_skip_relocation, catalina:      "0ecca1ff9c38b0ad88924f8ade628d2dd753eb0445da010ad03bf6e04efea3a4"
    sha256 cellar: :any_skip_relocation, mojave:        "a1ea0bfe1dccb23870b52005c92040458d7d92031bb5daced1c6dd944753ebba"
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
