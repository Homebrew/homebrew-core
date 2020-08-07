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
    sha256 "4a696f86bf0e22de32edec041319b1f6e96f07e3f359db5a013e798e2afef02d" => :catalina
    sha256 "c7dd6348d747810353165aec9d839caef298029198f031bcc3c3c443836e79a8" => :mojave
    sha256 "74346c75c6a779289f82afd2dd0ced98beb1e66ec34a7f1818c00db44e91d2c4" => :high_sierra
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
