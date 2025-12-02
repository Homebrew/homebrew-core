class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-6.0.0.tgz"
  sha256 "480a85e48da024092e1b63fe260f810880f5f82322d82f62304f32e970112216"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "888e67d06c5fbe66c72de1de9f759ed9f32fd7a88d9f2158c3626b13f9ecbca6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan --stdin", "hello, world!")
  end
end
