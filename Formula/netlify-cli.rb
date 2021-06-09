require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.35.10.tgz"
  sha256 "3a1d39ff4a2f576fb73a1c45f7dcf86c5be150b05741abe943c2f1f5e8db3756"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f94e383d240c3e9487820fe9e2fe5f9ba1ebe024fd09dcb5676b488815292228"
    sha256 cellar: :any_skip_relocation, big_sur:       "a79304738c8ff5d8a5923bbd4090fe840c700725be625ff5b4af9e53325991c4"
    sha256 cellar: :any_skip_relocation, catalina:      "a79304738c8ff5d8a5923bbd4090fe840c700725be625ff5b4af9e53325991c4"
    sha256 cellar: :any_skip_relocation, mojave:        "a79304738c8ff5d8a5923bbd4090fe840c700725be625ff5b4af9e53325991c4"
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
