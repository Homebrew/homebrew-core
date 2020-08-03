require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.59.0.tgz"
  sha256 "8531d8df8439cf8458f60b502aed81499eec5d7f285c03f7bca01a00dfa6bd3d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c07fa0ca8817032653bcf59e0454bb9eed029844410dc5d0a4ac00457041f50" => :catalina
    sha256 "e2c026acb4c0dbbd81b2bdfb95c923b8a4ff002190185cb1026692567eef5e32" => :mojave
    sha256 "b2cca2b6069979df9edef65af4c5e0e683d6f7bd55dcf1388b49ce81bf8d482f" => :high_sierra
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
