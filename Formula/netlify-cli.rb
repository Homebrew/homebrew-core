require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.5.tgz"
  sha256 "2d68e05c20e311aa61202ab06d85af482b3c325c6bc763581f116584ecf575e4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0fc1cfd9cc8531ad88ddd4b29f8ec4e4931a6230e1724b51795b06e71b433491" => :big_sur
    sha256 "2575ca0c1361f176ccd55cf3e9f3f28f8b4c3b8f379d6540a3cd96cf512795ca" => :arm64_big_sur
    sha256 "9d62d0ab617fe07e7f47306c9d7af595a221ad97711888f61a4010384c022215" => :catalina
    sha256 "315337fd4052727dd90c42b9db38e77a94bb8f65cca8b56c1b0441db4a359bb6" => :mojave
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
