require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.19.3.tgz"
  sha256 "9b887add37a5493cbe5834946c1ba56c0e774e854e8fe4ee6508a6980bc54e1d"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9fea4c461c7ccf0f6c024943a91802cdfeadfa73da829e78e4a87189456b36e" => :catalina
    sha256 "80979d147614904b36d4ed994a70324008a6f5a11355a9108055000cb8ce8470" => :mojave
    sha256 "043818a66d8277bab91f5db486a23b4be07d8fb82d6b7415c7a2b25b992649c4" => :high_sierra
  end

  depends_on "node"

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
